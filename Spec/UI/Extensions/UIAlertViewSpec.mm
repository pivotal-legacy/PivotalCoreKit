#import "SpecHelper.h"
#import "UIAlertView+PivotalCore.h"
#import "UIAlertView+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertViewSpec)

describe(@"UIAlertView", ^{
    __block UIAlertView *alertView;

    describe(@"initWithTitle:message:clickedBlock:cancelButtonTitle:otherButtonTitle:", ^{
        __block UIAlertViewClickedBlock clickedBlock;
        __block NSInteger selectedButtonIndex;

        NSString *title = @"Title", *message = @"Message", *cancelButtonText = @"Nope", *okButtonText = @"Yep";

        beforeEach(^{
            selectedButtonIndex = -1;
            clickedBlock = ^(NSInteger buttonIndex) {
                selectedButtonIndex = buttonIndex;
            };
            alertView = [[UIAlertView alloc] initWithTitle:title message:message clickedBlock:clickedBlock cancelButtonTitle:cancelButtonText otherButtonTitle:okButtonText];
        });

        it(@"should create the alert view with the specified properties", ^{
            alertView.message should equal(message);
            alertView.title should equal(title);
            alertView.numberOfButtons should equal(2);
            [alertView buttonTitleAtIndex:0] should equal(cancelButtonText);
        });

        context(@"when shown", ^{
            beforeEach(^{
                [alertView show];
            });

            it(@"should display the alert view normally", ^{
                UIAlertView.currentAlertView should equal(alertView);
            });

            context(@"and dismissed", ^{
                context(@"with the cancel button", ^{
                    beforeEach(^{
                        [alertView dismissWithCancelButton];
                    });

                    it(@"should call the specified block with the cancel button index", ^{
                        selectedButtonIndex should equal(alertView.cancelButtonIndex);
                    });
                });

                context(@"with a button other than the cancel button", ^{
                    NSInteger buttonIndex = 1;

                    beforeEach(^{
                        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
                    });

                    it(@"should call the specified block with the specified button index", ^{
                        selectedButtonIndex should equal(buttonIndex);
                    });
                });
            });
        });
    });
});

SPEC_END
