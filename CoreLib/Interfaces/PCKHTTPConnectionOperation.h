#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnectionOperation : NSOperation <NSURLConnectionDataDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
