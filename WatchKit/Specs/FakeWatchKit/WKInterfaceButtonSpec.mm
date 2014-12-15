#import "Cedar.h"
#import "WKInterfaceButton.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceButtonSpec)

describe(@"WKInterfaceButton", ^{
    __block NSMutableString *canary;
    __block WKInterfaceButton *subject;
    __block InterfaceController *controller;
    __block InterfaceControllerLoader *loader;

    beforeEach(^{
        canary = [[NSMutableString alloc] init];
        loader = [[InterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"AgC-eL-Hgc"
                                                           context:canary];
    });

    describe(@"tapping a button with an associated action", ^{
        beforeEach(^{
            subject = controller.actionButton;
            [subject tap];
        });

        it(@"should perform whatever task was specified in the button's action (in this case, changing the context string that was pased in)", ^{
            canary should equal(@"Tweet.");
        });
    });


    describe(@"tapping a button with no associated action", ^{
        beforeEach(^{
            subject = controller.noActionButton;
        });

        it(@"should allow the enabled property to be toggled programatically", ^{
            ^{ [subject tap]; } should_not raise_exception;
        });
    });

    describe(@"encountering an unexpected value when deserializing the segue", ^{
        __block NSDictionary *segueDictionary;
        beforeEach(^{
            subject = controller.noActionButton;
            segueDictionary = @{@"type": @"something_unexpected"};
        });

        it(@"should raise an exception with a helpful message", ^{
            ^ {
                [subject setValue:segueDictionary forKey:@"segue"];
            } should raise_exception
                .with_name(NSInvalidArgumentException)
                .with_reason(@"We encountered a new segue type, 'something_unexpected', in WatchKit.  This probably means that there is a new version of WatchKit that this library needs to be updated to support.");
        });
    });
});

SPEC_END
