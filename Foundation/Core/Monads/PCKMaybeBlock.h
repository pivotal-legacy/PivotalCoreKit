#import <Foundation/Foundation.h>
#import "PCKMonad.h"


@interface PCKMaybeBlock : NSObject <PCKMonad>

+ (instancetype)maybeWithBlock:(id (^)(id))f;
- (instancetype)initWithBlock:(id (^)(id))f;

- (instancetype)compose:(PCKMaybeBlock *)maybe;
- (instancetype)composeWithBlock:(id (^)(id))f;

- (id)call:(id)somethingOrNil;

@end
