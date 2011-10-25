#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnectionOperation : NSOperation <NSURLConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
