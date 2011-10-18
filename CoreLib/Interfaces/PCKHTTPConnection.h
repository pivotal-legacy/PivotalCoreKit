#import <Foundation/Foundation.h>

@class PCKHTTPInterface;

@interface PCKHTTPConnection : NSURLConnection <NSURLConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
