#import "CDRSpecHelper.h"
#import "UITableViewRowAction+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UITableViewRowAction_SpecSpec)

if (NSClassFromString(@"UITableViewRowAction")) {

describe(@"UITableVIewRowAction_SpecSpec", ^{
    __block UITableViewRowAction *action;
    __block BOOL handled;

    beforeEach(^{
        handled = NO;
        PCKTableViewRowActionHandler handler = ^(UITableViewRowAction *, NSIndexPath *){
            handled = YES;
        };

        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"spec" handler:handler];
        action.handler(action, [NSIndexPath indexPathForRow:0 inSection:0]);
    });

    it(@"should execute the handler", ^{
        handled should be_truthy;
    });
});

}

SPEC_END
