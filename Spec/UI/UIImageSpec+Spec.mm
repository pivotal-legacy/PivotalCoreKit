#import "SpecHelper.h"

#import "UIImage+Spec.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(UIImageSpec_Spec)

describe(@"UIImage+Spec", ^{
    __block UIImage *image1, *image2;

    describe(@"isEqualToByBytes:", ^{
        context(@"when the images are created from the same file", ^{
            beforeEach(^{
                image1 = [UIImage imageNamed:@"pivotallabs-logo"];
                image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pivotallabs-logo" ofType:@"png"]];
            });

            it(@"should return YES", ^{
                expect([image1 isEqualToByBytes:image2]).to(be_truthy());
            });
        });

        context(@"when the images are not created from the same file", ^{
            beforeEach(^{
                image1 = [UIImage imageNamed:@"pivotallabs-logo"];
                image2 = [UIImage imageNamed:@"logo-small"];
            });

            it(@"should return NO", ^{
                expect([image1 isEqualToByBytes:image2]).to_not(be_truthy());
            });
        });
    });
});

SPEC_END
