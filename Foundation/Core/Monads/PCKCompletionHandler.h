#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef __nullable id(^PCKCompletionHandlerBlock)(__nullable id,  NSURLResponse * __nullable , NSError * __nullable *);

@interface PCKCompletionHandler : NSObject

+ (instancetype)completionHandlerWithBlock:(PCKCompletionHandlerBlock)block;
- (instancetype)initWithBlock:(PCKCompletionHandlerBlock)block;

- (instancetype)compose:(PCKCompletionHandler *)completionHandler;
- (instancetype)composeWithBlock:(PCKCompletionHandlerBlock)block;

- (nullable id)callWith:(nullable id)value response:(nullable NSURLResponse *)response error:(nullable NSError *)error outError:(NSError * __nullable *)outError;

@end

NS_ASSUME_NONNULL_END
