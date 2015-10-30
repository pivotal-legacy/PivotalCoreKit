#import <Foundation/Foundation.h>

@class PCKHTTPInterface;

NS_ASSUME_NONNULL_BEGIN

@interface PCKHTTPConnection : NSURLConnection

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(nullable id<NSURLConnectionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
