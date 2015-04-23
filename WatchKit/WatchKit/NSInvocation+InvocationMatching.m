#import "NSInvocation+InvocationMatching.h"

@implementation NSInvocation (InvocationMatching)

- (BOOL)matchesTarget:(id)target selector:(SEL)selector arguments:(NSArray *)arguments
{
    if (self.selector != selector) {
        return NO;
    }

    if (self.target != target) {
        return NO;
    }

    NSInteger selectorArgumentCount = self.methodSignature.numberOfArguments - 2;

    if (selectorArgumentCount != arguments.count) {
        return NO;
    }

    for(NSInteger idx = 0; idx < selectorArgumentCount; idx++) {
        id argument = [arguments objectAtIndex:idx];
        __unsafe_unretained id retrievedArg;
        [self getArgument:&retrievedArg atIndex:idx + 2];
        if(retrievedArg != argument && ![retrievedArg isEqual:argument]) {
            return NO;
        };
    }

    return YES;
}
@end
