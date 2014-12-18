#import "CDRSpecHelper.h"
#import "UIAlertController+Spec.h"
#import "UIAlertView+Spec.h"
#import "UIAlertAction+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertControllerSpec)

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
                    [alertController dismissByTappingCancelButton];
                });

                it(@"should not tap the last button", ^{
                    handlerWasExecuted should be_falsy;
                });
            });

            itShouldBehaveLike(@"default cancel behavior");
        });
    });
});

SPEC_END
