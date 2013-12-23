#import "SpecHelper.h"
#import "NSString+PivotalCoreKit_UIKit.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSString_PivotalCoreKit_UIKitSpec)

describe(@"NSString_PivotalCoreKit_UIKit", ^{
    __block NSString *string;

    beforeEach(^{
        string = @"";
    });

    describe(@"heightWithWidth:font:", ^{
        __block CGFloat width;
        __block UIFont *font;
        __block CGFloat height;

        beforeEach(^{
            width = 300.0f;
            font = [UIFont systemFontOfSize:17.0f];
        });

        context(@"< iOS 7", ^{
            __block CGSize size;

            subjectAction(^{
                size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
                height = [string heightWithWidth:width font:font];
            });

            if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
                context(@"short string", ^{
                    beforeEach(^{
                        string = @"short string";
                    });

                    it(@"should return the correct height", ^{
                        height should equal(size.height);
                    });
                });

                context(@"long string", ^{
                    beforeEach(^{
                        string = @"really a very a long, probably unnecessarily long, string that undoubtedly will require several lines to render within the given height";
                    });

                    it(@"should return the correct height", ^{
                        height should equal(size.height);
                    });
                });
            }
        });


        context(@"iOS 7+", ^{
            __block CGRect rect;

            subjectAction(^{
                rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:@{NSFontAttributeName: font}
                                            context:nil];
                height = [string heightWithWidth:width font:font];
            });

            if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
                context(@"short string", ^{
                    beforeEach(^{
                        string = @"short string";
                    });

                    it(@"should return the correct height", ^{
                        height should equal(rect.size.height);
                    });
                });

                context(@"long string", ^{
                    beforeEach(^{
                        string = @"really a very a long, probably unnecessarily long, string that undoubtedly will require several lines to render within the given height";
                    });

                    it(@"should return the correct height", ^{
                        height should equal(rect.size.height);
                    });
                });
            }
        });

    });
});

SPEC_END
