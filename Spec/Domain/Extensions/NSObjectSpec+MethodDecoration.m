#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSObject+MethodDecoration.h"

@implementation NSObject (DecoratedDescription)
- (NSString *)descriptionWithBrackets {
    return [NSString stringWithFormat:@"[%@]", [self performSelector:@selector(descriptionWithoutBrackets)]];
}
@end


SPEC_BEGIN(NSObjectSpec_MethodDecoration)

describe(@"decorateMethod:with:", ^{
    __block NSObject *object;

    beforeEach(^{
        object = [[[NSObject alloc] init] autorelease];
    });

    it(@"should decorate the method", ^{
        NSString *description = [object description];
        [NSObject decorateMethod:@"description" with:@"brackets"];

        assertThat([object description], equalTo([NSString stringWithFormat:@"[%@]", description]));
    });
});

SPEC_END
