#import "PCKHTTPInterface.h"
#import "PCKHTTPConnection.h"

@interface PCKHTTPInterface (PCKHTTPConnectionFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end

@interface PCKHTTPConnection ()
@property (nonatomic, assign) PCKHTTPInterface *interface;
@property (nonatomic, retain) id <NSURLConnectionDelegate> connectionDelegate;
@end

@implementation PCKHTTPConnection

@synthesize interface = interface_, connectionDelegate = connectionDelegate_;

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithRequest:request delegate:self]) {
        self.interface = interface;
        self.connectionDelegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.connectionDelegate = nil;
    self.interface = nil;
    [super dealloc];
}

- (void)cancel {
    [super cancel];
    [self.interface clearConnection:self];
}

#pragma mark NSObject
- (BOOL)respondsToSelector:(SEL)selector {
    return [self.connectionDelegate respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return self.connectionDelegate;
}

#pragma mark NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.connectionDelegate connectionDidFinishLoading:connection];
    [self.interface clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.connectionDelegate connection:connection didFailWithError:error];
    [self.interface clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([self.connectionDelegate respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)]) {
        [self.connectionDelegate connection:connection didCancelAuthenticationChallenge:challenge];
    }
    [self.interface clearConnection:connection];
}

@end
