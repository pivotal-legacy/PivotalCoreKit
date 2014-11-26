#import <MacTypes.h>
#import "PCKMaybeBlock.h"

@implementation PCKMaybeBlock {
    id (^_f)(id);
}

+ (instancetype)maybeWithBlock:(id (^)(id))f
{
    return [[[self alloc] initWithBlock:f] autorelease];
}

- (instancetype)initWithBlock:(id (^)(id))f
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

- (instancetype)compose:(PCKMaybeBlock *)maybe
{
    NSParameterAssert(maybe);
    return [PCKMaybeBlock maybeWithBlock:^id(id o) {
        id inner = [maybe call:o];
        if (inner) {
            return [self call:inner];
        }
        return nil;
    }];
}

- (instancetype)composeWithBlock:(id (^)(id))f
{
    return [self compose:[PCKMaybeBlock maybeWithBlock:f]];
}

- (id)call:(id)somethingOrNil
{
    if (somethingOrNil) {
        return _f(somethingOrNil);
    }
    return nil;
}

@end
