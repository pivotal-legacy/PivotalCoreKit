#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#import "objc/runtime.h"
#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSObject+MethodRedirection.h"
#import "PCKConnectionDelegateWrapper.h"
#import "PCKConnectionBlockDelegate.h"

static char ASSOCIATED_REQUEST_KEY;
static char ASSOCIATED_DELEGATE_KEY;
static char REQUEST_IS_LIVE_KEY;
static char ASSOCIATED_SYNCHRONOUS_CONNECTION;

@interface NSURLConnection (Spec_Private)

- (id)originalInitWithRequest:(NSURLRequest *)request
                     delegate:(id)delegate
             startImmediately:(BOOL)startImmediately;
- (void)originalStart;
- (void)originalCancel;

@end

static NSMutableArray *connections__;
static NSOperationQueue *connectionsQueue;

@implementation NSURLConnection (Spec)

+ (void)beforeEach {
    [self resetAll];
    [connectionsQueue cancelAllOperations];
}

+ (void)initialize {
    connections__ = [[NSMutableArray alloc] init];
    connectionsQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection redirectSelector:@selector(initWithRequest:delegate:startImmediately:)
                                   to:@selector(pckInitWithRequest:delegate:startImmediately:)
                        andRenameItTo:@selector(originalInitWithRequest:delegate:startImmediately:)];

    [NSURLConnection redirectSelector:@selector(start)
                                   to:@selector(pckStart)
                        andRenameItTo:@selector(originalStart)];

    [NSURLConnection redirectSelector:@selector(cancel)
                                   to:@selector(pckCancel)
                        andRenameItTo:@selector(originalCancel)];
}

+ (NSArray *)connections {
    return connections__;
}

+ (NSURLConnection *)connectionForPath:(NSString *)path {
    for (NSURLConnection *connection in connections__) {
        if ([connection.request.URL.path isEqualToString:path]) {
            return connection;
        }
    }
    return nil;
}

+ (void)resetAll {
    [connections__ removeAllObjects];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    PCKConnectionBlockDelegate *delegate = [PCKConnectionBlockDelegate delegateWithBlock:handler];
    [[[self alloc] initWithRequest:request delegate:delegate] autorelease];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)pckInitWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    if ((self = [super init])) {
        [connections__ addObject:self];

        objc_setAssociatedObject(self, &ASSOCIATED_REQUEST_KEY, request, OBJC_ASSOCIATION_RETAIN);
        self.requestIsLive = NO;

        // NSURLConnection objects retain delegates, weirdly.  However, they are creepily smart
        // about not retaining the delegate if passed self as the delegate.
        objc_AssociationPolicy delegateAssociationPolicy = (delegate == self) ? OBJC_ASSOCIATION_ASSIGN : OBJC_ASSOCIATION_RETAIN;
        objc_setAssociatedObject(self, &ASSOCIATED_DELEGATE_KEY, delegate, delegateAssociationPolicy);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Test HTTP connection for request %@>", [self request]];
}

- (void)pckStart {
    if (self.requestIsLive) {
        [self originalStart];
    }
}

- (void)pckCancel {
    [connections__ removeObject:self];
    if (self.requestIsLive) {
        [self originalCancel];
        self.requestIsLive = NO;
    } else if (self.synchronousConnection) {
        [self.synchronousConnection cancel];
    }
}

- (NSURLRequest *)request {
    return objc_getAssociatedObject(self, &ASSOCIATED_REQUEST_KEY);
}

- (id)delegate {
    return objc_getAssociatedObject(self, &ASSOCIATED_DELEGATE_KEY);
}

#pragma mark - Synchronous Network Requests
+ (NSURLConnection *)liveConnectionWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    NSURLConnection *connection = [[[NSURLConnection alloc] originalInitWithRequest:request delegate:delegate startImmediately:NO] autorelease];
    connection.requestIsLive = YES;
    return connection;
}

- (void)setRequestIsLive:(BOOL)requestIsLive
{
    objc_setAssociatedObject(self, &REQUEST_IS_LIVE_KEY, [NSNumber numberWithBool:requestIsLive], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)requestIsLive
{
    return [objc_getAssociatedObject(self, &REQUEST_IS_LIVE_KEY) boolValue];
}

- (void)setSynchronousConnection:(NSURLConnection *)synchronousConnection
{
    objc_setAssociatedObject(self, &ASSOCIATED_SYNCHRONOUS_CONNECTION, synchronousConnection, OBJC_ASSOCIATION_RETAIN);
}

- (NSURLConnection *)synchronousConnection
{
    return objc_getAssociatedObject(self, &ASSOCIATED_SYNCHRONOUS_CONNECTION);
}

- (NSData *)fetchSynchronouslyWithTimeout:(NSTimeInterval)timeout
{
    __block BOOL finishedLoading = NO;
    __block NSData *receivedData = nil;
    
    PCKConnectionDelegateWrapper *wrapper = [PCKConnectionDelegateWrapper wrapperForConnection:self
                                                                            completionCallback:^(NSData *data){
        finishedLoading = YES;
        receivedData = data;
    }];
    
    self.synchronousConnection = [NSURLConnection liveConnectionWithRequest:[self.request copy]
                                                                   delegate:wrapper];
    self.synchronousConnection.delegateQueue = connectionsQueue;
    [self.synchronousConnection start];
    
    NSDate *startDate = [NSDate date];
    while (!finishedLoading && -[startDate timeIntervalSinceNow] < timeout && self.synchronousConnection.requestIsLive) {
        usleep(10000);
    }
    
    if (-[startDate timeIntervalSinceNow] >= timeout) {
        [self.delegate connection:self
                 didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil]];
    }

    [self.synchronousConnection cancel];
    
    [connections__ removeObject:self];
    
    return receivedData;
}

#pragma mark - Fake Responses

- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response {
    [self receiveResponse:response];
}

- (void)receiveResponse:(PSHKFakeHTTPURLResponse *)response {
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.delegate connection:self didReceiveResponse:response];
    }

    if ([connections__ containsObject:self] && [self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.delegate connection:self didReceiveData:[response bodyData]];
    }

    if ([connections__ containsObject:self]) {
        [self.delegate connectionDidFinishLoading:self];
    }

    [connections__ removeObject:self];
}

- (void)receiveSuccesfulResponseWithBody:(NSString *)responseBody
{
    [self receiveResponse:[[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                   andHeaders:nil
                                                                       andBody:responseBody] autorelease]];
}

- (void)failWithError:(NSError *)error {
    [[self delegate] connection:self didFailWithError:error];
    [connections__ removeObject:self];
}

- (void)failWithError:(NSError *)error data:(NSData *)data {
    if ([connections__ containsObject:self] && [self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.delegate connection:self didReceiveData:data];
    }

    [[self delegate] connection:self didFailWithError:error];
    [connections__ removeObject:self];
}

- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential {
    NSURLProtectionSpace *protectionSpace = [[[NSURLProtectionSpace alloc] initWithHost:@"www.example.com"
                                                                                   port:0
                                                                               protocol:@"http"
                                                                                  realm:nil
                                                                   authenticationMethod:nil]
                                             autorelease];
    NSURLAuthenticationChallenge *challenge = [[[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace
                                                                                          proposedCredential:credential
                                                                                        previousFailureCount:1
                                                                                             failureResponse:nil
                                                                                                       error:nil
                                                                                                      sender:nil]
                                               autorelease];

    [[self delegate] connection:self didReceiveAuthenticationChallenge:challenge];
}

@end
