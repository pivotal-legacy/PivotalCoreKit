#import "PCKCompletionHandler.h"


@implementation PCKCompletionHandler {
    PCKCompletionHandlerBlock _block;
}

+ (instancetype)completionHandlerWithBlock:(PCKCompletionHandlerBlock)block
{
    return [[[self alloc] initWithBlock:block] autorelease];
}

- (instancetype)initWithBlock:(PCKCompletionHandlerBlock)block
{
    NSParameterAssert(block);
    self = [super init];
    if (self) {
        _block = [block copy];
    }

    return self;
}

- (void)dealloc
{
    [_block release];
    [super dealloc];
}

- (instancetype)compose:(PCKCompletionHandler *)completionHandler
{
    NSParameterAssert(completionHandler);
    return [PCKCompletionHandler completionHandlerWithBlock:^id(id o, NSURLResponse *response, NSError **pError) {
        NSError *error = nil;
        id result = [completionHandler callWith:o response:response error:nil outError:&error];
        if (!error) {
            return [self callWith:result response:response error:nil outError:pError];
        } else if (pError) {
            *pError = error;
        }
        return result;
    }];
}

- (instancetype)composeWithBlock:(PCKCompletionHandlerBlock)block
{
    return [self compose:[PCKCompletionHandler completionHandlerWithBlock:block]];
}

- (id)callWith:(id)value response:(NSURLResponse *)response error:(NSError *)error outError:(NSError **)outError
{
    if (error) {
        if (outError) {
            *outError = error;
        }
        return value;
    }
    return _block(value, response, outError);
}

@end
