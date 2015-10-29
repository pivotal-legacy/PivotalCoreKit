#import "Cedar.h"
#import "UIAlertAction+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIAlertAction_SpecSpec)

if (NSClassFromString(@"UIAlertAction")) {

describe(@"UIAlertAction (spec extensions)", ^{
    __block UIAlertAction *action;
    __block BOOL handled;

    beforeEach(^{
        handled = NO;
        PCKAlertActionHandler handler = ^(UIAlertAction *){
            handled = YES;
        };

        action = [UIAlertAction actionWithTitle:@"any title" style:UIAlertActionStyleDefault handler:handler];
        action.handler(action);
    });

    it(@"should execute the handler", ^{
        handled should be_truthy;
    });
});

}

SPEC_END
