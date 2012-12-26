#import "PCKHTTPInterface.h"
#import "PCKHTTPConnectionDelegate.h"
#import "NSURLConnectionDelegate.h"

@interface PCKHTTPInterface (PCKHTTPConnectionDelegateFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end


@implementation PCKHTTPConnectionDelegate

@synthesize interface = interface_, delegate = delegate_;

+ (id)delegateWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate {
    return [[[self alloc] initWithInterface:interface delegate:delegate] autorelease];
}

- (id)initWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate {
    if ((self = [super init])) {
        self.interface = interface;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [delegate_ release];
    [super dealloc];
}

#pragma mark NSObject
- (BOOL)respondsToSelector:(SEL)selector {
    return [self.delegate respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return self.delegate;
}

#pragma mark NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:_cmd]) {
        [(id)self.delegate connectionDidFinishLoading:connection];
    }
    [self.interface clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate connection:connection didFailWithError:error];
    }
    [self.interface clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate connection:connection didCancelAuthenticationChallenge:challenge];
    }
    [self.interface clearConnection:connection];
}

@end
