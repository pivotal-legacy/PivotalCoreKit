#import <MacTypes.h>
#import "PCKErrorBlock.h"


@implementation PCKErrorBlock {
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


- (instancetype)compose:(PCKErrorBlock *)errorBlock
{
    NSParameterAssert(errorBlock);
    return [PCKErrorBlock errorWithBlock:^id(id success, NSError **errorPtr) {
        NSError *error = nil;
        id result = [errorBlock callWithSuccess:success error:&error];
        if (!error) {
            return [self callWithSuccess:result error:errorPtr];
        } else if (errorPtr) {
            *errorPtr = error;
        }
        return result;
    }];
}

- (instancetype)composeWithBlock:(id (^)(id, NSError **))f
{
    return [self compose:[PCKErrorBlock errorWithBlock:f]];
}

- (id)callWithSuccess:(id)success error:(NSError **)errorRef
{
    return _f(success, errorRef);
}

- (id)callWithFailure:(NSError *)error error:(NSError **)errorRef
{
    if (errorRef) {
        *errorRef = error;
    }
    return nil;
}

@end
