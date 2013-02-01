#import "SpecHelper.h"
#import "UIBarButtonItem+Spec.h"
#import "Target.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UIBarButtonItemSpec_Spec)

describe(@"UIBarButtonItemSpec_Spec", ^{
    __block UIBarButtonItem *barButtonItem;
    __block Target *target;

    beforeEach(^{
        target = [[Target new] autorelease];
    });

    it(@"can be 'tapped' programatically", ^{
        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:target
                                                                       action:@selector(callMe)] autorelease];
        [barButtonItem tap];
        target.wasCalled should be_truthy;
    });
});

SPEC_END
