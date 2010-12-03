#import <Foundation/Foundation.h>
#import "PCKHTTPConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnection : NSURLConnection <PCKHTTPConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<PCKHTTPConnectionDelegate>)delegate;

@end
