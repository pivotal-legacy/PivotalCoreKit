#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

NS_ASSUME_NONNULL_BEGIN

@interface PCKHTTPConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, retain, nullable) id<NSURLConnectionDelegate> delegate;
@property (nonatomic, assign) PCKHTTPInterface *interface;

+ (id)delegateWithInterface:(nullable PCKHTTPInterface *)interface delegate:(nullable id<NSURLConnectionDelegate>)delegate;
- (id)initWithInterface:(nullable PCKHTTPInterface *)interface delegate:(nullable id<NSURLConnectionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
