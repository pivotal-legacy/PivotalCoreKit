#import "PCKHTTPInterface.h"
#import "PCKHTTPConnection.h"
#import "PCKHTTPConnectionDelegate.h"

@interface PCKHTTPInterface (PCKHTTPConnectionFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end


@interface PCKHTTPConnection ()
@property (nonatomic, assign) PCKHTTPInterface *interface;
@end

@implementation PCKHTTPConnection

@synthesize interface = interface_;

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ((self = [super initWithRequest:request delegate:[PCKHTTPConnectionDelegate delegateWithInterface:interface delegate:delegate]])) {
#pragma clang diagnostic pop
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
