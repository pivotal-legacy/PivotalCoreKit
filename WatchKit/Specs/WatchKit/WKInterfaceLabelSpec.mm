#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceLabelSpec)

describe(@"WKInterfaceLabel", ^{
    __block WKInterfaceLabel *subject;

    beforeEach(^{
        subject = [[WKInterfaceLabel alloc] init];
    });

    describe(@"setters", ^{

        it(@"should record the invocation for setText: when called with a string", ^{
            [subject setText:@"qwer"];
            subject should have_received(@selector(setText:)).with(@"qwer");
        });

        it(@"should be able to assert the arguments to setText: without using the `have_received` matcher", ^{
            [subject setText:@"no special matchers needed!"];

            NSArray *labelMessages = [subject sent_messages];
            NSInvocation *firstLabelMessage = [labelMessages firstObject];
            __autoreleasing NSString *firstLabelMessageText;
            [firstLabelMessage getArgument:&firstLabelMessageText atIndex:2];
            firstLabelMessageText should equal(@"no special matchers needed!");
        });

        it(@"should record the invocation for setText: when called with a dictionary", ^{
            NSDictionary *textDictionary = @{@"fallbackString": @"Welcome Title",
                                             @"localizationKey": @"wla-Mc-WlR.text",
                                             };
            [subject setText:(id)textDictionary];
            subject should have_received(@selector(setText:)).with(@"Welcome Title");
        });

        it(@"should set the text property for setText: when called with a dictionary", ^{
            NSDictionary *textDictionary = @{@"fallbackString": @"Welcome Title",
                                             @"localizationKey": @"wla-Mc-WlR.text",
                                             };
            [subject setText:(id)textDictionary];
            subject.text should equal(@"Welcome Title");
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
