#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, retain) id<NSURLConnectionDelegate> delegate;
@property (nonatomic, assign) PCKHTTPInterface *interface;

+ (id)delegateWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate;
- (id)initWithInterface:(PCKHTTPInterface *)interface delegate:(id<NSURLConnectionDelegate>)delegate;

@end
