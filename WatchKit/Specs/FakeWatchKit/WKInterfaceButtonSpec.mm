#import "Cedar.h"
#import "WKInterfaceButton.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceButtonSpec)

describe(@"WKInterfaceButton", ^{
    __block WKInterfaceButton *subject;
    __block InterfaceController *controller;
    __block InterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[InterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"AgC-eL-Hgc"
                                                           context:nil];
    });

    describe(@"with an associated action", ^{
        beforeEach(^{
            subject = controller.actionButton;
        });

        it(@"should be configured with the specified task in the button's action", ^{
            subject.action should equal(@"didTapButton");
        });
    });


    describe(@"with no associated action", ^{
        beforeEach(^{
            subject = controller.noActionButton;
        });

        it(@"should not be configured with an action", ^{
            subject.action should be_nil;
        });
    });

    describe(@"encountering an unexpected value when deserializing the segue", ^{
        __block NSDictionary *segueDictionary;
        beforeEach(^{
            subject = controller.noActionButton;
            segueDictionary = @{@"type": @"something_unexpected"};
        });

        it(@"should raise an exception with a helpful message", ^{
            ^ {
                [subject setValue:segueDictionary forKey:@"segue"];
            } should raise_exception
                .with_name(NSInvalidArgumentException)
                .with_reason(@"We encountered a new segue type, 'something_unexpected', in WatchKit.  This probably means that there is a new version of WatchKit that this library needs to be updated to support.");
        });
    });
});

SPEC_END
