#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PCKConnectionAsynchronousRequestBlock)(NSURLResponse* __nullable, NSData* __nullable, NSError* __nullable);

@interface PCKConnectionBlockDelegate : NSObject <NSURLConnectionDataDelegate>

+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block;
+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block queue:(NSOperationQueue *)queue;

@end

NS_ASSUME_NONNULL_END
