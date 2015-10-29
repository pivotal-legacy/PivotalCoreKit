#import "Cedar.h"
#import "UIBarButtonItem+Spec.h"
#import "Target.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIBarButtonItemSpec_Spec)

describe(@"UIBarButtonItemSpec_Spec", ^{
    __block UIBarButtonItem *barButtonItem;
    __block Target *target;

    beforeEach(^{
        target = [[Target alloc] init];
        spy_on(target);

        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:target
                                                                       action:@selector(hello)];
    });

    it(@"can be 'tapped' programmatically", ^{
        [barButtonItem tap];
        target should have_received(@selector(hello));
    });

    it(@"should throw an exception if the bar button item is disabled", ^{
        barButtonItem.enabled = NO;
        ^{ [barButtonItem tap]; } should raise_exception;
    });

    it(@"should pass itself as sender if the action selector takes an argument", ^{
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:target
                                                                       action:@selector(ciao:)];
        [barButtonItem tap];
        target should have_received(@selector(ciao:)).with(barButtonItem);
    });

    it(@"should delegate down to the custom view if the custom view is a button", ^{
#if TARGET_OS_TV
        UIControlEvents event = UIControlEventPrimaryActionTriggered;
#else
        UIControlEvents event = UIControlEventTouchUpInside;
#endif

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:target
                   action:@selector(hello)
         forControlEvents:event];
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [barButtonItem tap];

        target should have_received(@selector(hello));
    });
});

SPEC_END
