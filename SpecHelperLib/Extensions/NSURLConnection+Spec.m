#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "PCKHTTPConnectionDelegate.h"
#import "objc/runtime.h"

static char ASSOCIATED_REQUEST_KEY;
static char ASSOCIATED_DELEGATE_KEY;

@implementation NSURLConnection (Spec)

static NSMutableArray *connections__;

+ (void)initialize {
    connections__ = [[NSMutableArray alloc] init];
}

+ (NSArray *)connections {
    return connections__;
}

+ (void)resetAll {
    [connections__ removeAllObjects];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    if (self = [super init]) {
        [connections__ addObject:self];

        objc_setAssociatedObject(self, &ASSOCIATED_REQUEST_KEY, request, OBJC_ASSOCIATION_RETAIN);

        // NSURLConnection objects retain delegates, weirdly.  However, they are creepily smart
        // about not retaining the delegate if passed self as the delegate.
        objc_AssociationPolicy delegateAssociationPolicy = (delegate == self) ? OBJC_ASSOCIATION_ASSIGN : OBJC_ASSOCIATION_RETAIN;
        objc_setAssociatedObject(self, &ASSOCIATED_DELEGATE_KEY, delegate, delegateAssociationPolicy);
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Test HTTP connection for request %@>", [self request]];
}

- (void)cancel {
    [connections__ removeObject:self];
}

- (NSURLRequest *)request {
    return objc_getAssociatedObject(self, &ASSOCIATED_REQUEST_KEY);
}

- (id)delegate {
    return objc_getAssociatedObject(self, &ASSOCIATED_DELEGATE_KEY);
}

- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response {
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.delegate connection:self didReceiveResponse:response];
    }

    if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.delegate connection:self didReceiveData:[[response body] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [self.delegate connectionDidFinishLoading:self];
}

- (void)failWithError:(NSError *)error {
    [[self delegate] connection:self didFailWithError:error];
}

- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential {
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"www.example.com" port:0 protocol:@"http" realm:nil authenticationMethod:nil];
    NSURLAuthenticationChallenge *challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:1 failureResponse:nil error:nil sender:nil];
    [protectionSpace release];

    [[self delegate] connection:self didReceiveAuthenticationChallenge:challenge];

    [challenge release];
}

@end
