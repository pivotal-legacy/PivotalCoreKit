#import <Foundation/Foundation.h>
#import "PCKMonad.h"


@interface PCKMaybe : NSObject <PCKMonad>

+ (instancetype)maybeWithBlock:(id (^)(id))f;
- (instancetype)initWithBlock:(id (^)(id))f;

- (instancetype)compose:(PCKMaybe *)maybe;

- (void)callWithJust:(id)just andOnNone:(void(^)())onNone;
- (void)callWithNoneAndOnNone:(void(^)())onNone;
- (void)callWith:(id)justOrNothing andOnNone:(void(^)())onNone;

@end
