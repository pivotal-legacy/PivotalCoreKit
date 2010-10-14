#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnection : NSURLConnection <NSURLConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
