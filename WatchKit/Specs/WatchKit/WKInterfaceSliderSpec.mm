#import "Cedar.h"
#import "SliderController.h"
#import "NSBundle+BuildHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceSliderSpec)

describe(@"WKInterfaceSlider", ^{
    __block WKInterfaceSlider *subject;
    __block SliderController *controller;
    __block PCKInterfaceControllerLoader *loader;
    beforeEach(^{
        loader = [[PCKInterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"MySliderController"
                                                            bundle:[NSBundle buildHelperBundle]];
        subject = controller.slider;
    });

    describe(@"setters", ^{
        it(@"should record the sent message for setting the enabled property", ^{
            [subject setEnabled:NO];
            subject should have_received(@selector(setEnabled:)).with(NO);
        });

        it(@"should record the sent message for setting the value", ^{
            float mySpecialValue = 1234.5678f;
            [subject setValue:mySpecialValue];
            subject should have_received(@selector(setValue:)).with(mySpecialValue);
        });

        it(@"should record the sent message for setting the color", ^{
            [subject setColor:[UIColor yellowColor]];
            subject should have_received(@selector(setColor:)).with([UIColor yellowColor]);
        });

        it(@"should record the sent message for setting the number of steps", ^{
            [subject setNumberOfSteps:7];
            subject should have_received(@selector(setNumberOfSteps:)).with(7);
        });
    });
});

SPEC_END
