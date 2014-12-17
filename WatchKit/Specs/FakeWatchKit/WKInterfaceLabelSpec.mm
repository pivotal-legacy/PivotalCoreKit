#import "Cedar.h"
#import "WKInterfaceLabel.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceLabelSpec)

describe(@"WKInterfaceLabel", ^{
    __block WKInterfaceLabel *subject;

    beforeEach(^{
        subject = [[WKInterfaceLabel alloc] init];
    });

    describe(@"setters", ^{
        it(@"should record the invocation for setText:", ^{
            [subject setText:@"qwer"];
            subject should have_received(@selector(setText:)).with(@"qwer");
        });

        it(@"should record the invocation for setTextColor:", ^{
            [subject setTextColor:[UIColor grayColor]];
            subject should have_received(@selector(setTextColor:)).with([UIColor grayColor]);
        });

        it(@"should record the invocation for setAttributedText:", ^{
            NSAttributedString *attributedString = [[NSAttributedString alloc] init];
            [subject setAttributedText:attributedString];
            subject should have_received(@selector(setAttributedText:)).with(attributedString);
        });
    });
});

SPEC_END
