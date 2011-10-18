#import <Foundation/Foundation.h>

@class PCKHTTPInterface;

@interface PCKHTTPConnectionOperation : NSOperation <NSURLConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
