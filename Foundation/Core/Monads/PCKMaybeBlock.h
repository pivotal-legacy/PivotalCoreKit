#import <Foundation/Foundation.h>
#import "PCKMonad.h"

NS_ASSUME_NONNULL_BEGIN

@interface PCKMaybeBlock : NSObject <PCKMonad>

+ (instancetype)maybeWithBlock:(__nullable id (^)(__nonnull id))f;
- (instancetype)initWithBlock:(__nullable id (^)(__nonnull id))f;

- (instancetype)compose:(PCKMaybeBlock *)maybe;
- (instancetype)composeWithBlock:(__nullable id (^)(__nonnull id))f;

- (nullable id)call:(nullable id)somethingOrNil;

@end

NS_ASSUME_NONNULL_END
