#import <Foundation/Foundation.h>


typedef id(^PCKCompletionHandlerBlock)(id, NSURLResponse *, NSError **);

@interface PCKCompletionHandler : NSObject

+ (instancetype)completionHandlerWithBlock:(PCKCompletionHandlerBlock)block;
- (instancetype)initWithBlock:(PCKCompletionHandlerBlock)block;

- (instancetype)compose:(PCKCompletionHandler *)completionHandler;
- (instancetype)composeWithBlock:(PCKCompletionHandlerBlock)block;

- (id)callWith:(id)value response:(NSURLResponse *)response error:(NSError *)error outError:(NSError **)outError;

@end
