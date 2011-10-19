#import "PCKHTTPInterface.h"
#import "PCKHTTPConnection.h"

@interface PCKHTTPInterface (PCKHTTPConnectionFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end

@interface PCKHTTPConnectionDelegate : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) id<NSURLConnectionDelegate> delegate;
@property (nonatomic, assign) PCKHTTPInterface *interface;

+ (id)delegateWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate;
- (id)initWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate;

@end

@implementation PCKHTTPConnectionDelegate

@synthesize interface = interface_, delegate = delegate_;

+ (id)delegateWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate {
    return [[[self alloc] initWithInterface:interface delegate:delegate] autorelease];
}

- (id)initWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super init]) {
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



@interface PCKHTTPConnection ()
@property (nonatomic, assign) PCKHTTPInterface *interface;
@end

@implementation PCKHTTPConnection

@synthesize interface = interface_;

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithRequest:request delegate:[PCKHTTPConnectionDelegate delegateWithInterface:interface delegate:delegate]]) {
        self.interface = interface;
    }
    return self;
}

- (void)dealloc {
    self.interface = nil;
    [super dealloc];
}

- (void)cancel {
    [super cancel];
    [self.interface clearConnection:self];
}

@end
