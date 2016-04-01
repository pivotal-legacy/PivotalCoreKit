#import "Cedar.h"
#import "UIAlertController+Spec.h"
#import "UIAlertView+Spec.h"
#import "UIAlertAction+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertControllerSpec)

if (NSClassFromString(@"UIAlertController")) {

describe(@"UIAlertController (spec extensions)", ^{
    __block UIAlertController *alertController;
    __block BOOL handlerWasExecuted;
    __block BOOL presentedControllerWasDismissedBeforeActionHandlerCall;
    __block PCKAlertActionHandler handler;
    __block UIViewController *presentingController;

    void (^addCancelAction)(UIAlertController *, PCKAlertActionHandler) = ^(UIAlertController *controller, PCKAlertActionHandler handler){
        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:handler]];
    };

    void (^addDefaultAction)(UIAlertController *, PCKAlertActionHandler) = ^(UIAlertController *controller, PCKAlertActionHandler handler){
        [controller addAction:[UIAlertAction actionWithTitle:@"Default"
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler]];
    };

    beforeEach(^{
        presentingController = [UIViewController new];
        handlerWasExecuted = NO;
        handler = ^(UIAlertAction *) {
            handlerWasExecuted = YES;
            presentedControllerWasDismissedBeforeActionHandlerCall = presentingController.presentedViewController == nil;
        };
    });

    describe(@"-dismissByTappingCancelButton", ^{
        beforeEach(^{
            alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                  message:@"Message"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            addDefaultAction(alertController, nil);
        });

        sharedExamplesFor(@"alert controller with a cancel button", ^(NSDictionary *sharedContext) {
            describe(@"tapping the cancel button", ^{
                context(@"containing a UIAlertActionStyleCancel button", ^{
                    beforeEach(^{
                        addCancelAction(alertController, handler);
                        addDefaultAction(alertController, nil);

                        [alertController dismissByTappingCancelButton];
                    });

                    it(@"should call the handler for the cancel button", ^{
                        handlerWasExecuted should be_truthy;
                    });

                    it(@"should dismiss the controller before the action handler is executed", ^{
                        presentedControllerWasDismissedBeforeActionHandlerCall should be_truthy;
                    });
                });

                context(@"with a cancel button with no action", ^{
                    beforeEach(^{
                        addCancelAction(alertController, nil);
                    });

                    it(@"should not raise exception", ^{
                        ^{ [alertController dismissByTappingCancelButton]; } should_not raise_exception;
                    });
                });
            });
        });

        sharedExamplesFor(@"alert controller has no cancel button", ^(NSDictionary *sharedContext) {
            beforeEach(^{
                addDefaultAction(alertController, handler);
            });

            it(@"should blow up", ^{
                ^{ [alertController dismissByTappingCancelButton]; } should raise_exception;
            });

        });

        describe(@"UIAlertControllerStyleAlert", ^{
            beforeEach(^{
                [presentingController presentViewController:alertController animated:NO completion:nil];
            });

            itShouldBehaveLike(@"alert controller with a cancel button");
            itShouldBehaveLike(@"alert controller has no cancel button");
        });

        describe(@"UIAlertControllerStyleActionSheet", ^{
            beforeEach(^{
                alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                      message:@"Message"
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                [presentingController presentViewController:alertController animated:NO completion:nil];
            });

            itShouldBehaveLike(@"alert controller with a cancel button");
            itShouldBehaveLike(@"alert controller has no cancel button");
        });

        context(@"when presented outside of a view controller", ^{
            it(@"should raise an exception", ^{
                ^{ [alertController dismissByTappingCancelButton]; } should raise_exception;
            });
        });
    });

    describe(@"-dismissByTappingButtonWithTitle:", ^{
        describe(@"UIAlertControllerStyleAlert", ^{
            beforeEach(^{
                alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                      message:@"Message"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [presentingController presentViewController:alertController animated:NO completion:nil];
            });

            context(@"when there is a button with a title", ^{
                beforeEach(^{
                    addCancelAction(alertController, nil);
                    addDefaultAction(alertController, handler);
                    [alertController dismissByTappingButtonWithTitle:@"Default"];
                });

                it(@"should call the handler for the action with the same title", ^{
                    handlerWasExecuted should be_truthy;
                });

                it(@"should dismiss the controller before the action handler is executed", ^{
                    presentedControllerWasDismissedBeforeActionHandlerCall should be_truthy;
                });

                it(@"should dismiss the alert controller", ^{
                    presentingController.presentedViewController should be_nil;
                });
            });

            context(@"when there is not a button with a title", ^{
                beforeEach(^{
                    addDefaultAction(alertController, nil);
                    addDefaultAction(alertController, handler);
                });

                it(@"should raise an exception stating a button with that title does not exist", ^{
                    ^{ [alertController dismissByTappingButtonWithTitle:@"Non-existant"]; } should raise_exception;
                });
            });

            context(@"when the button does not have an action", ^{
                beforeEach(^{
                    addDefaultAction(alertController, nil);
                });

                it(@"should not blow up", ^{
                    ^{ [alertController dismissByTappingButtonWithTitle:@"Default"]; } should_not raise_exception;
                });
            });

            context(@"when there is no presenting view controller", ^{
                beforeEach(^{
                    addDefaultAction(alertController, handler);
                    [alertController dismissByTappingButtonWithTitle:@"Default"];
                });

                it(@"should raise an exception", ^{
                    ^{ [alertController dismissByTappingButtonWithTitle:@"Default"]; } should raise_exception;
                });
            });
        });
    });
});

}

SPEC_END
