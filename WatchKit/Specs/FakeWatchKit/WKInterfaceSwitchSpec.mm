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
                                                                             identifier:@"AgC-eL-Hgc"
                                                                                context:nil];
        subject = controller.theSwitch;
    });

    describe(@"tapping the switch", ^{
        beforeEach(^{
            [subject tap];
        });

        it(@"should toggle the on property", ^{
            subject.on should_not be_truthy;
        });
    });
});

SPEC_END
