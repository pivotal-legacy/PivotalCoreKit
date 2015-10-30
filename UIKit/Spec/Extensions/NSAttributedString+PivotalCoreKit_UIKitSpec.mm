#import "Cedar.h"
#import "NSAttributedString+PivotalCoreKit_UIKit.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSAttributedString_PivotalCoreKit_UIKitSpec)

describe(@"NSAttributedString_PivotalCoreKit_UIKit", ^{
    __block NSAttributedString *attributedString;

    beforeEach(^{
        attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    });

    describe(@"heightWithWidth:", ^{
        __block CGFloat width;
        __block CGRect rect;
        __block CGFloat height;

        subjectAction(^{
            rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                  options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  context:nil];
            height = [attributedString heightWithWidth:width];
        });

        beforeEach(^{
            width = 300.0f;
        });

        context(@"short string", ^{
            beforeEach(^{
                attributedString = [[NSAttributedString alloc] initWithString:@"short string" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            });

            it(@"should return the correct height", ^{
                height should equal(rect.size.height);
            });
        });

        context(@"long string", ^{
            beforeEach(^{
                attributedString = [[NSAttributedString alloc] initWithString:@"really a very a long, probably unnecessarily long, string that undoubtedly will require several lines to render within the given height" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
            });

            it(@"should return the correct height", ^{
                height should equal(rect.size.height);
            });
        });
    });
});

SPEC_END
