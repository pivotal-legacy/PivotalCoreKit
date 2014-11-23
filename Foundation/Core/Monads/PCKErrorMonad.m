#import <MacTypes.h>
#import "PCKErrorMonad.h"


@implementation PCKErrorMonad {
    id (^_f)(id, NSError **);
}

+ (instancetype)errorWithBlock:(id (^)(id, NSError **))f
{
    return [[[self alloc] initWithBlock:f] autorelease];
}

- (instancetype)initWithBlock:(id (^)(id, NSError **))f
{
    NSParameterAssert(f);
    self = [super init];
    if (self) {
        _f = [f copy];
    }

    return self;
}

- (void)dealloc
{
    [_f release];
    [super dealloc];
}


- (instancetype)compose:(PCKErrorMonad *)errorMonad
{
    return [[[PCKErrorMonad alloc] initWithBlock:^id(id success, NSError **errorPtr) {
        NSError *error = nil;
        id inner = errorMonad->_f(success, &error);
        if (inner) {
            id result = _f(inner, &error);
            if (result) {
                return success;
            }
        }
        *errorPtr = error;
        return nil;
    }] autorelease];
}

- (void)callWithSuccess:(id)success andOnFailure:(void (^)(NSError *))onFailure
{
    NSError *error;
    id result = _f(success, &error);
    if (!result && onFailure) {
        onFailure(error);
    }
}

- (void)callWithFailure:(NSError *)failure andOnFailure:(void (^)(NSError *))onFailure
{
    if (onFailure) {
        onFailure(failure);
    }
}

@end
