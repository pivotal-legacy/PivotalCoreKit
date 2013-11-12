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
        spy_on(target);

        barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:target
                                                                       action:@selector(hello)] autorelease];
    });

    it(@"can be 'tapped' programmatically", ^{
        [barButtonItem tap];
        target should have_received(@selector(hello));
    });
    
    it(@"should throw an exception if the bar button item is disabled", ^{
        barButtonItem.enabled = NO;
        expect(^{[barButtonItem tap];}).to(raise_exception());
    });
    
    it(@"should delegate down to the custom view if the custom view is a button", ^{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:target action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        [barButtonItem tap];

        target should have_received(@selector(hello));
    });
    
});

SPEC_END
