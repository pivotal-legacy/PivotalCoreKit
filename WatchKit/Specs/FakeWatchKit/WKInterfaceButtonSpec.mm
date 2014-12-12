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

    beforeEach(^{
        canary = [[NSMutableString alloc] init];
        InterfaceControllerLoader *loader = [[InterfaceControllerLoader alloc] init];
        InterfaceController *controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                                             identifier:@"AgC-eL-Hgc"
                                                                                context:canary];
        subject = controller.button;
    });

    describe(@"tapping the button", ^{
        beforeEach(^{
            [subject tap];
        });

        it(@"should perform whatever task was specified in the button's action (in this case, changing the context string that was pased in)", ^{
            canary should equal(@"Tweet.");
        });
    });
});

SPEC_END
