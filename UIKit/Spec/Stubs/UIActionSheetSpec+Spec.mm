#import "CDRSpecHelper.h"
#import "UIActionSheet+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIActionSheetSpecExtensionsSpec)

describe(@"UIActionSheet (spec extensions)", ^{
    __block UIActionSheet *actionSheet;

    beforeEach(^{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Man of action"
                                                  delegate:nil
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Destructive"
                                         otherButtonTitles:@"Yes more action please", nil];
    });

    describe(@"after presenting an action sheet", ^{
        beforeEach(^{
            UIView *presentingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];

            [actionSheet showInView:presentingView];
        });

        it(@"is presented", ^{
            actionSheet.isVisible should be_truthy;
            [UIActionSheet currentActionSheet] should be_same_instance_as(actionSheet);
        });

        describe(@"resetting UIActionSheet", ^{
            beforeEach(^{
                [UIActionSheet reset];
            });

            it(@"clears the current actionsheet", ^{
                [UIActionSheet currentActionSheet] should be_nil;
            });
        });

        describe(@"dismissing the action sheet", ^{
            __block id<UIActionSheetDelegate> delegate;
            beforeEach(^{
                delegate = nice_fake_for(@protocol(UIActionSheetDelegate));

                actionSheet.delegate = delegate;

                [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            });

            it(@"is no longer the current or visible actionSheet", ^{
                actionSheet.isVisible should be_falsy;
                [UIActionSheet currentActionSheet] should be_nil;
            });

            it(@"calls delegate callback methods", ^{
                delegate should have_received(@selector(actionSheet:clickedButtonAtIndex:))
                .with(actionSheet, 0);

                delegate should have_received(@selector(actionSheet:willDismissWithButtonIndex:))
                .with(actionSheet, 0);

                delegate should have_received(@selector(actionSheet:didDismissWithButtonIndex:))
                .with(actionSheet, 0);
            });
        });
    });

    describe(@"ways to present action sheets", ^{
        sharedExamplesFor(@"an actionSheet presenter", ^(NSDictionary *sharedContext) {
            describe(@"+currentActionSheet", ^{
                it(@"returns the actionSheet", ^{
                    [UIActionSheet currentActionSheet] should be_same_instance_as(actionSheet);
                });
            });

            describe(@"+currentActionSheetView", ^{
                it(@"describes the view the action sheet was presented from", ^{
                    [UIActionSheet currentActionSheetView] should be_same_instance_as(sharedContext[@"presentingView"]);
                });
            });

            it(@"is visible", ^{
                actionSheet.isVisible should be_truthy;
            });
        });

        describe(@"showing in view", ^{
            __block UIView *presentingView;

            beforeEach(^{
                presentingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];

                [actionSheet showInView:presentingView];
                [SpecHelper specHelper].sharedExampleContext[@"presentingView"] = presentingView;
            });

            itShouldBehaveLike(@"an actionSheet presenter");
        });

        describe(@"showing from bar button item", ^{
            beforeEach(^{
                UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];

                [actionSheet showFromBarButtonItem:buttonItem animated:YES];
                [SpecHelper specHelper].sharedExampleContext[@"presentingView"] = buttonItem;
            });

            itShouldBehaveLike(@"an actionSheet presenter");
        });

        describe(@"showing from toolbar", ^{
            beforeEach(^{
                UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

                [actionSheet showFromToolbar:toolbar];
                [SpecHelper specHelper].sharedExampleContext[@"presentingView"] = toolbar;
            });

            itShouldBehaveLike(@"an actionSheet presenter");
        });

        describe(@"showing from tab bar", ^{
            beforeEach(^{
                UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];

                [actionSheet showFromTabBar:tabBar];
                [SpecHelper specHelper].sharedExampleContext[@"presentingView"] = tabBar;
            });

            itShouldBehaveLike(@"an actionSheet presenter");
        });

        describe(@"showing from rect", ^{
            __block UIView *presentingView;

            beforeEach(^{
                presentingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];

                [actionSheet showFromRect:CGRectMake(30, 30, 10, 10)
                                   inView:presentingView
                                 animated:YES];
                [SpecHelper specHelper].sharedExampleContext[@"presentingView"] = presentingView;
            });

            itShouldBehaveLike(@"an actionSheet presenter");
        });
    });

    describe(@"methods that have nothing to do with stubbing", ^{
        describe(@"button titles", ^{
            it(@"should contain titles from buttons", ^{
                actionSheet.buttonTitles should equal(@[@"Destructive",
                                                        @"Yes more action please",
                                                        @"Cancel"]);
            });
        });

        describe(@"clicking a button by title", ^{
            __block id<UIActionSheetDelegate> delegate;
            beforeEach(^{
                delegate = nice_fake_for(@protocol(UIActionSheetDelegate));

                actionSheet.delegate = delegate;

                [actionSheet dismissByClickingButtonWithTitle:@"Cancel"];
            });

            it(@"dismisses with corresponding index", ^{
                delegate should have_received(@selector(actionSheet:didDismissWithButtonIndex:))
                .with(actionSheet, actionSheet.cancelButtonIndex);
            });
        });

        describe(@"dismissing with destructive button", ^{
            __block id<UIActionSheetDelegate> delegate;
            beforeEach(^{
                delegate = nice_fake_for(@protocol(UIActionSheetDelegate));

                actionSheet.delegate = delegate;

                [actionSheet dismissByClickingDestructiveButton];
            });

            it(@"dismisses with destructive index", ^{
                delegate should have_received(@selector(actionSheet:didDismissWithButtonIndex:))
                .with(actionSheet, actionSheet.destructiveButtonIndex);
            });
        });

        describe(@"dismissing with cancel button", ^{
            __block id<UIActionSheetDelegate> delegate;
            beforeEach(^{
                delegate = nice_fake_for(@protocol(UIActionSheetDelegate));

                actionSheet.delegate = delegate;

                [actionSheet dismissByClickingCancelButton];
            });

            it(@"dismisses with cancel index", ^{
                delegate should have_received(@selector(actionSheet:didDismissWithButtonIndex:))
                .with(actionSheet, actionSheet.cancelButtonIndex);
            });
        });
    });
});

SPEC_END
