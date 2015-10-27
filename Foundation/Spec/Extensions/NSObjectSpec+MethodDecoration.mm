#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "NSObject+MethodDecoration.h"

using namespace Cedar::Matchers;

@interface NSObject (DecoratedDescriptionDeclaration)
- (NSString *)descriptionWithoutBrackets;
@end

@implementation NSObject (DecoratedDescription)
- (NSString *)descriptionWithBrackets {
    return [NSString stringWithFormat:@"[%@]", [self performSelector:@selector(descriptionWithoutBrackets)]];
}
@end

SPEC_BEGIN(NSObjectSpec_MethodDecoration)

describe(@"decorateMethod:with:", ^{
    __block NSObject *object;

    beforeEach(^{
        object = [[NSObject alloc] init];
    });

    it(@"should decorate the method", ^{
        NSString *undecoratedDescription = object.description;
        [NSObject decorateMethod:@"description" with:@"brackets"];

        NSString *decoratedDescription = object.description;
        expect(decoratedDescription).to(equal([NSString stringWithFormat:@"[%@]", undecoratedDescription]));
    });
});

SPEC_END
