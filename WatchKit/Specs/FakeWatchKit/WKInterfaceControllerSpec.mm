#import "Cedar.h"
#import "CorgisController.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "WKInterfaceController.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceControllerSpec)

describe(@"WKInterfaceController", ^{
    __block InterfaceController *subject;

    beforeEach(^{
        InterfaceControllerLoader *loader = [[InterfaceControllerLoader alloc] init];
        subject = [loader interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc" context:@""];

    });

    describe(@"pushing another controller onto itself", ^{
        __block CorgisController *childController;
        beforeEach(^{
            [subject pushControllerWithName:@"MyFirstCorgiController" context:[UIImage imageNamed:@"corgi.jpeg"]];
            childController = (id)subject.childController;
        });

        it(@"should have a new child controller with the correct interface controller class", ^{
            childController should be_instance_of([CorgisController class]);
        });

        it(@"should receive the context that was passed in", ^{
            childController.image.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
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
});

SPEC_END
