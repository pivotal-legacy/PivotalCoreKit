#import "UISpecHelper.h"
#import "OCMock.h"

#import "UIAlertView+Spec.h"

namespace Cedar { namespace Matchers {
    class BeVisible : public Base {
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

SPEC_BEGIN(UIAlertViewSpecExtensionsSpec)

describe(@"UIAlertView (spec extensions)", ^{
    __block UIAlertView *alertView;
    __block id mockDelegate;

    beforeEach(^{
        mockDelegate = [OCMockObject niceMockForProtocol:@protocol(UIAlertViewDelegate)];
        alertView = [[[UIAlertView alloc] initWithTitle:@"Title"
                                                message:@"Message"
                                               delegate:mockDelegate
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK", nil] autorelease];
    });

    describe(@"Getting the current alert view with currentAlertView", ^{
        describe(@"when the alert view is not shown", ^{
            beforeEach(^{
                expect(alertView).to_not(be_visible());
            });

            it(@"should return nil", ^{
                expect([UIAlertView currentAlertView]).to(be_nil());
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
            it(@"should notify the delegate passing in the appropriate button", ^{
                [[mockDelegate expect] alertView:alertView clickedButtonAtIndex:alertView.cancelButtonIndex];
                [[mockDelegate expect] alertView:alertView willDismissWithButtonIndex:alertView.cancelButtonIndex];
                [[mockDelegate expect] alertView:alertView didDismissWithButtonIndex:alertView.cancelButtonIndex];

                [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];

                [mockDelegate verify];
            });
        });

        describe(@"when the alertView is dismissed with the other button", ^{
            it(@"should notify the delegate passing in the appropriate button", ^{
                [[mockDelegate expect] alertView:alertView clickedButtonAtIndex:alertView.firstOtherButtonIndex];
                [[mockDelegate expect] alertView:alertView willDismissWithButtonIndex:alertView.firstOtherButtonIndex];
                [[mockDelegate expect] alertView:alertView didDismissWithButtonIndex:alertView.firstOtherButtonIndex];

                [alertView dismissWithClickedButtonIndex:alertView.firstOtherButtonIndex animated:NO];

                [mockDelegate verify];
            });
        });
    });
});

SPEC_END
