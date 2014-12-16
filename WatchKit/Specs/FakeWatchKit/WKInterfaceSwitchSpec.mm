#import "Cedar.h"
#import "WKInterfaceSwitch.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceSwitchSpec)

describe(@"WKInterfaceSwitch", ^{
    __block WKInterfaceSwitch *subject;

    beforeEach(^{
        InterfaceControllerLoader *loader = [[InterfaceControllerLoader alloc] init];
        InterfaceController *controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                                             identifier:@"AgC-eL-Hgc"];
        subject = controller.theSwitch;
    });

    describe(@"setters", ^{

        it(@"should record the fact that setEnabled: was called", ^{
            [subject setEnabled:YES];
            subject should have_received(@selector(setEnabled:)).with(YES);
        });

        it(@"should record the fact that setOn: was called", ^{
            [subject setOn:YES];
            subject should have_received(@selector(setOn:)).with(YES);
        });
    });
});

SPEC_END
