#import "Cedar.h"
#import "CorgisController.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "WKInterfaceController.h"
#import "FakeSegue.h"
#import "FakeInterfaceController.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceControllerSpec)

describe(@"WKInterfaceController", ^{
    __block InterfaceController *subject;
    __block InterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[InterfaceControllerLoader alloc] init];
        subject = [loader interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc" context:@""];

    });

    describe(@"pushing another controller onto itself", ^{
        __block FakeInterfaceController *childController;
        beforeEach(^{
            [subject pushControllerWithName:@"MyFirstCorgiController" context:[UIImage imageNamed:@"corgi.jpeg"]];
            childController = (id)subject.childController;
        });

        it(@"should have a new child controller with the correct interface controller class", ^{
            childController.name should equal(@"MyFirstCorgiController");
        });

        it(@"should receive the context that was passed in", ^{
            childController.context should equal([UIImage imageNamed:@"corgi.jpeg"]);
        });
    });

    describe(@"present another controller modally", ^{
        __block CorgisController *presentedController;
        beforeEach(^{
            [subject presentControllerWithName:@"MyFirstCorgiController" context:[UIImage imageNamed:@"corgi.jpeg"]];
            presentedController = (id)subject.presentedController;
        });

        it(@"should present a new modal controller with the correct interface controller class", ^{
            presentedController should be_instance_of([CorgisController class]);
        });

        it(@"should receive the context that was passed in", ^{
            presentedController.image.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
        });
    });

    describe(@"triggering an interface object's segue", ^{
        describe(@"push action", ^{
            __block id<TestableWKInterfaceButton> seguePushButton;
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
            __block id<TestableWKInterfaceButton> segueModalButton;
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

        describe(@"modal action", ^{
            __block id<TestableWKInterfaceButton> segueModalButton;
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
