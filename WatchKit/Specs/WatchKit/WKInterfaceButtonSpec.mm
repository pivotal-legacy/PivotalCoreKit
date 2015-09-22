#import "Cedar.h"
#import "InterfaceController.h"
#import "NSBundle+BuildHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceButtonSpec)

describe(@"WKInterfaceButton", ^{
    __block WKInterfaceButton *subject;
    __block InterfaceController *controller;
    __block PCKInterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[PCKInterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"AgC-eL-Hgc"
                                                            bundle:[NSBundle buildHelperBundle]];
    });

    describe(@"with an associated action", ^{
        beforeEach(^{
            subject = controller.actionButton;
        });

        it(@"should be configured with the specified task in the button's action", ^{
            subject.action should equal(@"didTapButton");
        });

        it(@"should be able to run the associated action", ^{
            controller.tapCount should equal(0);

            [subject triggerNonSegueAction];

            controller.tapCount should equal(1);
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

    describe(@"setters", ^{
        beforeEach(^{
            subject = [[WKInterfaceButton alloc] init];
        });

        it(@"should record the invocation for setTitle:", ^{
            [subject setTitle:@"asdf"];

            subject should have_received(@selector(setTitle:)).with(@"asdf");
        });

        it(@"should record the invocation for setColor:", ^{
            UIColor *color = [UIColor redColor];
            [subject setColor:color];

            subject should have_received(@selector(setColor:)).with(color);
        });

        it(@"should record the invocation for setAttributedTitle:", ^{
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"asdf"];
            [subject setAttributedTitle:string];

            subject should have_received(@selector(setAttributedTitle:)).with([[NSAttributedString alloc] initWithString:@"asdf"]);
        });

        it(@"should record the invocation for setBackgroundImage:", ^{
            UIImage *image = [UIImage imageNamed:@"corgi.jpeg"];
            [subject setBackgroundImage:image];

            subject should have_received(@selector(setBackgroundImage:)).with(image);
        });

        it(@"should record the invocation for setBackgroundImageData:", ^{
            NSData *data = [NSData data];
            [subject setBackgroundImageData:data];

            subject should have_received(@selector(setBackgroundImageData:)).with(data);
        });

        it(@"should record the invocation for setBackgroundImageNamed:", ^{
            [subject setBackgroundImageNamed:@"asdf"];

            subject should have_received(@selector(setBackgroundImageNamed:)).with(@"asdf");
        });

        it(@"should record the invocation for setEnabled:", ^{
            [subject setEnabled:YES];

            subject should have_received(@selector(setEnabled:)).with(YES);
        });
    });
});

SPEC_END
