#import <Cedar/SpecHelper.h>

#import "NSObject+MethodDecoration.h"

using namespace Cedar::Matchers;

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
        NSString *undecoratedDescription = object.description;
        [NSObject decorateMethod:@"description" with:@"brackets"];

        NSString *decoratedDescription = object.description;
        expect(decoratedDescription).to(equal([NSString stringWithFormat:@"[%@]", undecoratedDescription]));
    });
});

SPEC_END
