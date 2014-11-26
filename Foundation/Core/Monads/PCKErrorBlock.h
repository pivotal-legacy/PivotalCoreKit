#import <Foundation/Foundation.h>
#import "PCKMonad.h"


@interface PCKErrorBlock : NSObject <PCKMonad>

+ (instancetype)errorWithBlock:(id (^)(id, NSError **))f;
- (instancetype)initWithBlock:(id (^)(id, NSError **))f;

- (instancetype)compose:(PCKErrorBlock *)errorBlock;
- (instancetype)composeWithBlock:(id (^)(id, NSError **))f;

- (id)callWithSuccess:(id)success error:(NSError **)errorRef;
- (id)callWithFailure:(NSError *)error error:(NSError **)errorRef;

@end
