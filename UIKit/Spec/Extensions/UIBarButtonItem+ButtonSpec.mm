#import "Cedar.h"
#import "UIBarButtonItem+Button.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(UIBarButtonItem_ButtonSpec)

describe(@"UIBarButtonItem_Button", ^{
    __block UIButton *button;
    __block UIBarButtonItem *barButtonItem;

    beforeEach(^{
        button = [[UIButton alloc] init];
        barButtonItem = [UIBarButtonItem barButtonItemUsingButton:button];
    });

    it(@"should use the button as the custom view", ^{
        barButtonItem.customView should equal(button);
    });

    it(@"should expose the button as a property", ^{
        barButtonItem.button should equal(button);
    });

    it(@"should return nil for button if the bar button item is created in another way", ^{
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
        barButtonItem.button should be_nil();
    });
});

SPEC_END
