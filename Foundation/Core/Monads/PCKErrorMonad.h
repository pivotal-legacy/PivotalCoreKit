#import <Foundation/Foundation.h>
#import "PCKMonad.h"


@interface PCKErrorMonad : NSObject <PCKMonad>

+ (instancetype)errorWithBlock:(id (^)(id, NSError **))f;
- (instancetype)initWithBlock:(id (^)(id, NSError **))f;

- (instancetype)compose:(PCKErrorMonad *)errorMonad;

- (void)callWithSuccess:(id)success andOnFailure:(void(^)(NSError *))onFailure;
- (void)callWithFailure:(NSError *)failure andOnFailure:(void(^)(NSError *))onFailure;

@end
