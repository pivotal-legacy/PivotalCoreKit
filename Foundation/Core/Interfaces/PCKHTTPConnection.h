#import <Foundation/Foundation.h>

@class PCKHTTPInterface;

@interface PCKHTTPConnection : NSURLConnection

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
