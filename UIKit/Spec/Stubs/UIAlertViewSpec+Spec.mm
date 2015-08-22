#import "CDRSpecHelper.h"
#import "UIAlertView+Spec.h"

namespace Cedar { namespace Matchers {
    class BeVisible : public Base<> {
    public:
        virtual NSString * failure_message_end() const { return @"be visible"; }
        template<typename T>
        bool matches(T * const view) const { return view.isVisible; }
    };

    inline BeVisible be_visible() {
        return BeVisible();
    }
}}

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertViewSpecExtensionsSpec)

describe(@"UIAlertView (spec extensions)", ^{
    __block UIAlertView *alertView;
    __block id<UIAlertViewDelegate, CedarDouble> delegate;

    beforeEach(^{
        delegate = nice_fake_for(@protocol(UIAlertViewDelegate));
        alertView = [[UIAlertView alloc] initWithTitle:@"Title"
                                               message:@"Message"
                                              delegate:delegate
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"OK", nil];
    });

    describe(@"getting the current alert view with currentAlertView", ^{
        describe(@"when the alert view is not shown", ^{
            beforeEach(^{
                expect(alertView).to_not(be_visible());
            });

            it(@"should return nil", ^{
                expect([UIAlertView currentAlertView]).to(be_nil());
            });
        });

        describe(@"when multiple alert views are being shown", ^{
            __block UIAlertView *otherAlertView;

            beforeEach(^{
                [alertView show];
                otherAlertView = [[UIAlertView alloc] initWithTitle:@"Another title"
                                                            message:@"Oy vey"
                                                           delegate:delegate
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
                [otherAlertView show];

                UIAlertView *aThirdAlertView = [[UIAlertView alloc] initWithTitle:@"I'm going away soon"
                                                                          message:@"Real soon now"
                                                                         delegate:delegate
                                                                cancelButtonTitle:@"Cancel"
                                                                otherButtonTitles:nil];
                [aThirdAlertView show];
                [aThirdAlertView dismissWithCancelButton];
            });

            it(@"should return the most recently shown alert view that wasn't dismissed", ^{
                expect([UIAlertView currentAlertView]).to(be_same_instance_as(otherAlertView));
            });
        });

        describe(@"when the alert view is shown", ^{
            beforeEach(^{
                [alertView show];
            });

            it(@"should return the alert view", ^{
                expect([UIAlertView currentAlertView]).to(equal(alertView));
            });

            describe(@"when the alertView is subsequently dismissed", ^{
                beforeEach(^{
                    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
                });

                it(@"should return nil", ^{
                    expect([UIAlertView currentAlertView]).to(be_nil());
                });
            });

            describe(@"when the UIAlertView class is subsequently reset", ^{
                beforeEach(^{
                    [UIAlertView reset];
                });

                it(@"should return nil", ^{
                    expect([UIAlertView currentAlertView]).to(be_nil());
                });
            });
        });
    });

    describe(@"checking visibility with isVisible", ^{
        describe(@"when the alert view is not shown", ^{
            it(@"should return NO", ^{
                expect(alertView.isVisible).to(equal(NO));
            });
        });

        describe(@"when the alert view is shown", ^{
            beforeEach(^{
                [alertView show];
            });

            it(@"should return YES", ^{
                expect(alertView.isVisible).to(equal(YES));
            });

            describe(@"when the UIAlertView class is subsequently dismissed", ^{
                beforeEach(^{
                    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
                });

                it(@"should return NO", ^{
                    expect(alertView.isVisible).to(equal(NO));
                });
            });
        });
    });

    describe(@"forwarding callbacks", ^{
        describe(@"when the alertView is dismissed with the cancel button", ^{
            beforeEach(^{
                [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
            });

            it(@"should notify the delegate, passing in the appropriate button", ^{
                delegate should have_received("alertView:clickedButtonAtIndex:").with(alertView).and_with(alertView.cancelButtonIndex);
                delegate should have_received("alertView:willDismissWithButtonIndex:").with(alertView).and_with(alertView.cancelButtonIndex);
                delegate should have_received("alertView:didDismissWithButtonIndex:").with(alertView).and_with(alertView.cancelButtonIndex);
            });
        });

        describe(@"when the alertView is dismissed with the other button", ^{
            beforeEach(^{
                [alertView dismissWithClickedButtonIndex:alertView.firstOtherButtonIndex animated:NO];
            });

            it(@"should notify the delegate passing in the appropriate button", ^{
                delegate should have_received("alertView:clickedButtonAtIndex:").with(alertView).and_with(alertView.firstOtherButtonIndex);
                delegate should have_received("alertView:willDismissWithButtonIndex:").with(alertView).and_with(alertView.firstOtherButtonIndex);
                delegate should have_received("alertView:didDismissWithButtonIndex:").with(alertView).and_with(alertView.firstOtherButtonIndex);
            });
        });
    });
});

SPEC_END
