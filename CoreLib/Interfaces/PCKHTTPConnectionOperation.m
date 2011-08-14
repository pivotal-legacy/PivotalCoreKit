#import "PCKHTTPConnectionOperation.h"
#import "PCKHTTPConnection.h"

@interface PCKHTTPConnectionOperation ()
@property (nonatomic, assign) PCKHTTPInterface *interface;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) id<PCKHTTPConnectionDelegate> connectionDelegate;
@property (nonatomic, assign) BOOL isExecuting, isFinished;
@end

@implementation PCKHTTPConnectionOperation

@synthesize interface = interface_, request = request_, connection = connection_,
    connectionDelegate = connectionDelegate_, isExecuting = isExecuting_, isFinished = isFinished_;

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<PCKHTTPConnectionDelegate>)delegate {
    if (self = [super init]) {
        self.interface = interface;
        self.request = request;
        self.connectionDelegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.connection = nil;
    self.connectionDelegate = nil;
    self.interface = nil;
    [super dealloc];
}

#pragma mark NSObject
- (BOOL)respondsToSelector:(SEL)selector {
    return [super respondsToSelector:selector] || [self.connectionDelegate respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return self.connectionDelegate;
}

#pragma mark NSOperation
- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }

    self.isExecuting = YES;
    self.connection = [[[PCKHTTPConnection alloc] initWithHTTPInterface:self.interface forRequest:self.request andDelegate:self] autorelease];

    // Stay alive
}

- (void)cancel {
    self.isExecuting = NO;
    self.isFinished = YES;
    [self.connection cancel];
}

#pragma mark PCKHTTPConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.isExecuting = NO;
    self.isFinished = YES;
    [self.connectionDelegate connectionDidFinishLoading:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.isExecuting = NO;
    self.isFinished = YES;
    [self.connectionDelegate connection:connection didFailWithError:error];
}

@end
