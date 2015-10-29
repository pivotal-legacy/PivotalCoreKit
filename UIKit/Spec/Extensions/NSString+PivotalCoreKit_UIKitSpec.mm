#import "Cedar.h"
#import "NSString+PivotalCoreKit_UIKit.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSString_PivotalCoreKit_UIKitSpec)

describe(@"NSString_PivotalCoreKit_UIKit", ^{

    describe(@"heightWithWidth:font:", ^{
        __block UIFont *font;

        beforeEach(^{
            font = [UIFont systemFontOfSize:17.0f];
        });

        it(@"should return the height for short strings", ^{
            [@"one line" heightWithWidth:150.0f font:font] should be_close_to(21.0f).within(1.0f);
        });

        it(@"should return the height for strings that wrap onto many lines", ^{
            NSString *string = @"Really really really really really really really really really really really really really long string";
            [string heightWithWidth:150.0f font:font] should be_close_to(105.0f).within(5.0f);
        });

    });
});

SPEC_END
