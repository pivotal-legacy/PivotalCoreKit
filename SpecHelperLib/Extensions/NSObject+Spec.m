#import "NSObject+Spec.h"
#import "PSHKRunQueue.h"

static PSHKRunQueue *runQueue__;

@implementation NSObject (Spec)

+ (PSHKRunQueue *)runQueue {
    if (!runQueue__) {
        runQueue__ = [[PSHKRunQueue alloc] init];
    }
    return runQueue__;
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay {
    [[[self class] runQueue] addJobForObject:self selector:aSelector delay:delay];
}



+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(id)anArgument {
    [[self runQueue] cancelJobForObject:aTarget selector:aSelector];

}

@end
