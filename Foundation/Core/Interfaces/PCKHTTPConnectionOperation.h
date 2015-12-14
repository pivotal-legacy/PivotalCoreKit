#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

NS_ASSUME_NONNULL_BEGIN

@interface PCKHTTPConnectionOperation : NSOperation <NSURLConnectionDataDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(nullable id<NSURLConnectionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
