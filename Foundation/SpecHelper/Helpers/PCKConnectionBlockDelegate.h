#import <Foundation/Foundation.h>

typedef void(^PCKConnectionAsynchronousRequestBlock)(NSURLResponse*, NSData*, NSError*);

@interface PCKConnectionBlockDelegate : NSObject <NSURLConnectionDataDelegate>

+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block;
+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block queue:(NSOperationQueue *)queue;

@end
