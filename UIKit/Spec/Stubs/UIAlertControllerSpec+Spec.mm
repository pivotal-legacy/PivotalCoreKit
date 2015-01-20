#import "CDRSpecHelper.h"
#import "UIAlertController+Spec.h"
#import "UIAlertView+Spec.h"
#import "UIAlertAction+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertControllerSpec)

#ifdef __IPHONE_8_0
if (NSClassFromString(@"UIAlertController")) {
    describe(@"UIAlertController (spec extensions)", ^{
        __block UIAlertController *alertController;
        __block BOOL handlerWasExecuted;
        __block PCKAlertActionHandler handler;

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
            handlerWasExecuted = NO;
            handler = ^(UIAlertAction *) { handlerWasExecuted = YES; };
        });

        describe(@"-dismissByTappingCancelButton", ^{
            sharedExamplesFor(@"default cancel behavior", ^(NSDictionary *sharedContext) {
                describe(@"tapping the cancel button", ^{
                    context(@"containing a UIAlertActionStyleCancel button", ^{
                        beforeEach(^{
                            addCancelAction(alertController, handler);
                            addDefaultAction(alertController, nil);

                            [alertController dismissByTappingCancelButton];
                        });

                        it(@"should tap the cancel button regardless of where it is", ^{
                            handlerWasExecuted should be_truthy;
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

            describe(@"UIAlertControllerStyleAlert", ^{
                beforeEach(^{
                    alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                          message:@"Message"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                    addDefaultAction(alertController, nil);
                });

                context(@"without containing a UIAlertActionStyleCancel button", ^{
                    beforeEach(^{
                        addDefaultAction(alertController, handler);
                        [alertController dismissByTappingCancelButton];
                    });

                    it(@"should tap the last button", ^{
                        handlerWasExecuted should be_truthy;
                    });
                });

                itShouldBehaveLike(@"default cancel behavior");
            });

            describe(@"UIAlertControllerStyleActionSheet", ^{
                beforeEach(^{
                    alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                          message:@"Message"
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
                });

                context(@"when a action sheet does not have a cancel button", ^{
                    beforeEach(^{
                        addDefaultAction(alertController, handler);
                    });

                    it(@"should blow up", ^{
                        ^{ [alertController dismissByTappingCancelButton]; } should raise_exception;
                    });
                });

                itShouldBehaveLike(@"default cancel behavior");
            });
        });

        describe(@"-dismissByTappingButtonWithTitle:", ^{
            describe(@"UIAlertControllerStyleAlert", ^{
                beforeEach(^{
                    alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                          message:@"Message"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                });

                context(@"when there is a button with a title", ^{
                    beforeEach(^{
                        addCancelAction(alertController, nil);
                        addDefaultAction(alertController, handler);
                        [alertController dismissByTappingButtonWithTitle:@"Default"];
                    });

                    it(@"should tap the button", ^{
                        handlerWasExecuted should be_truthy;
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
            });
        });

    });
}
#endif

SPEC_END
