#import "Cedar.h"
#import "CorgisController.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "WKInterfaceController.h"
#import "WKInterfaceButton+Spec.h"
#import "FakeSegue.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceControllerSpec)

describe(@"WKInterfaceController", ^{
    __block InterfaceController *subject;
    __block InterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[InterfaceControllerLoader alloc] init];
        subject = [loader interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc"];

    });

    describe(@"public methods", ^{

        it(@"should record the invocations of awakeWithContext:", ^{
            [subject awakeWithContext:@1];

            subject should have_received(@selector(awakeWithContext:)).with(@1);
        });

        it(@"should record the invocations of willActivate", ^{
            subject should_not be_nil;
            [subject willActivate];

            subject should have_received(@selector(willActivate));
        });

        it(@"should record the invocations of didDeactivate", ^{
            [subject didDeactivate];

            subject should have_received(@selector(didDeactivate));
        });

        it(@"should record the invocations of table:didSelectRowAtIndex:", ^{
            WKInterfaceTable *table = [[WKInterfaceTable alloc] init];
            [subject table:table didSelectRowAtIndex:0];

            subject should have_received(@selector(table:didSelectRowAtIndex:)).with(table, 0);
        });

        it(@"should record the invocations of handleActionWithIdentifier:forRemoteNotification:", ^{
            [subject handleActionWithIdentifier:@"asdf" forRemoteNotification:@{@"a": @1}];
            subject should have_received(@selector(handleActionWithIdentifier:forRemoteNotification:)).with(@"asdf", @{@"a": @1});
        });

        it(@"should record the invocations of handleActionWithIdentifier:forLocalNotification:", ^{
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            [subject handleActionWithIdentifier:@"asdf" forLocalNotification:notification];
            subject should have_received(@selector(handleActionWithIdentifier:forLocalNotification:)).with(@"asdf", notification);
        });

        it(@"should record the invocations of handleActionWithIdentifier:forRemoteNotification:", ^{
            NSString *expectedContext = @"asdf";
            [subject actionForUserActivity:@{@"a": @1} context:&expectedContext];
            subject should have_received(@selector(actionForUserActivity:context:)).with(@{@"a": @1}, Arguments::anything);

            NSInvocation *invocation = [[subject sent_messages] firstObject];
            __autoreleasing NSString **contextPointer;
            [invocation getArgument:&contextPointer atIndex:3];
            NSString *context = *contextPointer;
            context should equal(@"asdf");
        });

        it(@"should record the invocations of setTitle:", ^{
            [subject setTitle:@"asdf"];
            subject should have_received(@selector(setTitle:)).with(@"asdf");
        });

        it(@"should record the invocations of pushControllerWithName:context:", ^{
            [subject pushControllerWithName:@"MyFirstCorgiController" context:[UIImage imageNamed:@"corgi.jpeg"]];

            subject should have_received(@selector(pushControllerWithName:context:)).with(@"MyFirstCorgiController", [UIImage imageNamed:@"corgi.jpeg"]);
        });

        it(@"should record the invocations of popController", ^{
            [subject popController];
            subject should have_received(@selector(popController));
        });

        it(@"should record the invocations of popToRootController", ^{
            [subject popToRootController];
            subject should have_received(@selector(popToRootController));
        });

        it(@"should record the invocations of becomeCurrentPage", ^{
            [subject becomeCurrentPage];

            subject should have_received(@selector(becomeCurrentPage));
        });

        it(@"should record the invocations of presentControllerWithName:context:", ^{
            [subject presentControllerWithName:@"MyFirstCorgiController" context:[UIImage imageNamed:@"corgi.jpeg"]];
            subject should have_received(@selector(presentControllerWithName:context:)).with(@"MyFirstCorgiController", [UIImage imageNamed:@"corgi.jpeg"]);
        });

        it(@"should record the invocations of presentControllerWithName:contexts:", ^{
            NSArray *names = @[@"sally", @"charlie"];
            NSArray *contexts = @[@2, @3];
            [subject presentControllerWithNames:names contexts:contexts];
            subject should have_received(@selector(presentControllerWithNames:contexts:)).with(names, contexts);
        });

        it(@"should record the invocations of dismissController", ^{
            [subject dismissController];

            subject should have_received(@selector(dismissController));
        });
    });

    describe(@"triggering an interface object's segue", ^{
        describe(@"push action", ^{
            __block WKInterfaceButton *seguePushButton;
            beforeEach(^{
                seguePushButton = subject.seguePushButton;
                seguePushButton.segue should_not be_nil;
            });

            it(@"should have the correct segue configuration", ^{
                seguePushButton.segue.type should equal(FakeSegueTypePush);
            });

            it(@"should have the correct segue destination identifier", ^{
                seguePushButton.segue.destinationIdentifier should equal(@"MyFirstCorgiController");
            });
        });

        describe(@"modal action", ^{
            __block WKInterfaceButton *segueModalButton;
            beforeEach(^{
                segueModalButton = subject.segueModalButton;
                segueModalButton.segue should_not be_nil;
            });

            it(@"should have the correct segue configuration", ^{
                segueModalButton.segue.type should equal(FakeSegueTypeModal);
            });

            it(@"should have the correct segue destination identifier", ^{
                segueModalButton.segue.destinationIdentifier should equal(@"MyModalCorgiController");
            });
        });
    });
});

SPEC_END
