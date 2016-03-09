#import "Cedar.h"
#import "UIViewController+Spec.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UIViewControllerSpecExtensionsSpec)

describe(@"UIViewController (spec extensions)", ^{
    __block UIViewController *controller, *childController;
    __block UINavigationController *modalController;

    beforeEach(^{
        controller = [[UIViewController alloc] init];
        childController = [[UIViewController alloc] init];
        modalController = [[UINavigationController alloc] initWithRootViewController:childController];
    });

    describe(@"presenting modal view controllers", ^{

        context(@"when pck_useSpecStubs:YES was called (it should have been called during +load)", ^{
            __block NSInteger numberOfTimesCompletionBlockCalled;

            beforeEach(^{
                numberOfTimesCompletionBlockCalled = 0;
                [controller presentViewController:modalController animated:YES completion:^{
                    numberOfTimesCompletionBlockCalled++;
                }];
            });

            it(@"should invoke the complete block once", ^{
                numberOfTimesCompletionBlockCalled should equal(1);
            });

            it(@"should set the presentedViewController as the modal controller", ^{
                controller.presentedViewController should be_same_instance_as(modalController);
            });

            it(@"should set the presentingViewController on the modal controller", ^{
                modalController.presentingViewController should be_same_instance_as(controller);
            });

            describe(@"dismissing the modal using a child view controller", ^{
                beforeEach(^{
                    numberOfTimesCompletionBlockCalled = 0;
                    [childController dismissViewControllerAnimated:YES completion:^{
                        numberOfTimesCompletionBlockCalled++;
                    }];
                });

                it(@"should invoke the complete block once", ^{
                    numberOfTimesCompletionBlockCalled should equal(1);
                });

                it(@"should remove the presented view controller", ^{
                    controller.presentedViewController should be_nil;
                });

                it(@"should remove the presenting view controller", ^{
                    modalController.presentingViewController should be_nil;
                });
            });

            describe(@"dismissing the modal using the parent view controller", ^{
                beforeEach(^{
                    numberOfTimesCompletionBlockCalled = 0;
                    [controller dismissViewControllerAnimated:YES completion:^{
                        numberOfTimesCompletionBlockCalled++;
                    }];
                });

                it(@"should invoke the complete block once", ^{
                    numberOfTimesCompletionBlockCalled should equal(1);
                });

                it(@"should remove the presented view controller", ^{
                    controller.presentedViewController should be_nil;
                });

                it(@"should remove the presenting view controller", ^{
                    modalController.presentingViewController should be_nil;
                });
            });

            describe(@"dismissing the modal using the modal view controller", ^{
                beforeEach(^{
                    numberOfTimesCompletionBlockCalled = 0;
                    [modalController dismissViewControllerAnimated:YES completion:^{
                        numberOfTimesCompletionBlockCalled++;
                    }];
                });

                it(@"should invoke the complete block once", ^{
                    numberOfTimesCompletionBlockCalled should equal(1);
                });

                it(@"should remove the presented view controller", ^{
                    controller.presentedViewController should be_nil;
                });

                it(@"should remove the presenting view controller", ^{
                    modalController.presentingViewController should be_nil;
                });
            });
            
            describe(@"presenting another modal controller", ^{
                it(@"should raise an exception", ^{
                    ^{
                        UIViewController *viewController = [[UIViewController alloc] init];
                        [controller presentViewController:viewController animated:YES completion:nil];
                    } should raise_exception;
                });
            });
        });

        context(@"when pck_useSpecStubs:NO was called", ^{
            __block UIWindow *window;

            beforeEach(^{
                window = [[UIWindow alloc] init];
                window.rootViewController = controller;
                [window makeKeyAndVisible];
            });

            it(@"should use the default UIKit version of presentViewController:animated:completion: "
               @"(which does not set the presentedViewController property synchronously)", ^{
                   [UIViewController pck_useSpecStubs:NO];

                   __block BOOL completionBlockCalled = NO;
                   [controller presentViewController:modalController
                                            animated:YES
                                          completion:^{
                                              completionBlockCalled = YES;
                                          }];
                   completionBlockCalled should_not be_truthy;

                   [UIViewController pck_useSpecStubs:YES];
               });


            it(@"should use the default UIKit version of presentViewController:animated:completion: "
               @"(which does not unset the presentedViewController property synchronously)", ^{
                   [controller presentViewController:modalController animated:YES completion:nil];
                   controller.presentedViewController should be_same_instance_as(modalController);

                   [UIViewController pck_useSpecStubs:NO];

                   __block BOOL completionBlockCalled = NO;
                   [controller dismissViewControllerAnimated:YES completion:^{
                       completionBlockCalled = YES;
                   }];

                   completionBlockCalled should_not be_truthy;

                   [UIViewController pck_useSpecStubs:YES];
               });
        });
    });

#if !TARGET_OS_TV

    describe(@"presenting modal view controllers (deprecated APIs)", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        beforeEach(^{
            [controller presentModalViewController:modalController animated:YES];
        });

        it(@"should set the presentedViewController as the modal controller", ^{
            controller.presentedViewController should be_same_instance_as(modalController);
        });

        describe(@"dismissing the modal using a child view controller", ^{
            beforeEach(^{
                [childController dismissModalViewControllerAnimated:YES];
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });

        describe(@"dismissing the modal using the parent view controller", ^{
            beforeEach(^{
                [controller dismissModalViewControllerAnimated:YES];
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });
#pragma clang diagnostic pop
    });

#endif

    describe(@"transitioning between child view controllers", ^{
        __block UIViewController *parentController;
        __block UIViewController *oldChildController;
        __block UIViewController *newChildController;
        __block UIView *parentControllerContentView;

        beforeEach(^{
            parentController = [[UIViewController alloc] init];
            oldChildController = [[UIViewController alloc] init];
            newChildController = [[UIViewController alloc] init];
            parentControllerContentView = [[UIView alloc] init];

            [parentController.view addSubview:parentControllerContentView];

            [parentController addChildViewController:oldChildController];

            [parentControllerContentView addSubview:oldChildController.view];
            [oldChildController didMoveToParentViewController:parentController];

            [parentController transitionFromViewController:oldChildController
                                          toViewController:newChildController
                                                  duration:0
                                                   options:UIViewAnimationOptionCurveEaseInOut
                                                animations:nil
                                                completion:nil];
        });

        it(@"should add the newChildController's view to oldChildController's view's superview", ^{
            newChildController.view.superview should equal(parentControllerContentView);
        });

        it(@"should remove the oldChildController's view from its superview", ^{
            oldChildController.view.superview should be_nil;
        });
    });
});

SPEC_END
