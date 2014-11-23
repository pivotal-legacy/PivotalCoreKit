#import <MacTypes.h>
#import "PCKMaybe.h"

@implementation PCKMaybe {
    id (^_f)(id);
}

+ (instancetype)maybeWithBlock:(id (^)(id))f
{
    return [[[self alloc] initWithBlock:f] autorelease];
}

- (instancetype)initWithBlock:(id (^)(id))f
{
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

- (instancetype)compose:(PCKMaybe *)maybe
{
    return [[PCKMaybe maybeWithBlock:^id(id o) {
        id inner = maybe->_f(o);
        if (inner) {
            id result = _f(inner);
            if (result) {
                return result;
            }
        }
        return nil;
    }] autorelease];
}

- (void)callWithJust:(id)just andOnNone:(void (^)())onNone
{
    NSParameterAssert(just);
    id result = _f(just);
    if (!result && onNone) {
        onNone();
    }
}

- (void)callWithNoneAndOnNone:(void (^)())onNone
{
    if (onNone) {
        onNone();
    }
}

- (void)callWith:(id)justOrNothing andOnNone:(void (^)())onNone
{
    if (justOrNothing) {
        [self callWithJust:justOrNothing andOnNone:onNone];
    } else {
        [self callWithNoneAndOnNone:onNone];
    }
}

@end
