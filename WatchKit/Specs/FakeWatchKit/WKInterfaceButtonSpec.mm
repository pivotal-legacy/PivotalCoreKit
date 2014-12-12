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
});

SPEC_END
