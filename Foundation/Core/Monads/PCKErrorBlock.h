#import <Foundation/Foundation.h>
#import "PCKMonad.h"

NS_ASSUME_NONNULL_BEGIN

@interface PCKErrorBlock : NSObject <PCKMonad>

+ (instancetype)errorWithBlock:(__nullable id (^)(__nullable id, NSError * __nullable *))f;
- (instancetype)initWithBlock:(__nullable id (^)(__nullable id, NSError * __nullable *))f;

- (instancetype)compose:(PCKErrorBlock *)errorBlock;
- (instancetype)composeWithBlock:(__nullable id (^)(__nullable id, NSError * __nullable *))f;

- (nullable id)callWithSuccess:(nullable id)success error:(NSError * __nullable *)errorRef;
- (nullable id)callWithFailure:(NSError *)error error:(NSError * __nullable *)errorRef;

@end

NS_ASSUME_NONNULL_END
