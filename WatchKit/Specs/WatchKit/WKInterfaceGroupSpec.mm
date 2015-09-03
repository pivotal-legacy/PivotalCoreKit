#import "Cedar.h"
#import "GroupController.h"
#import "NSBundle+BuildHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceGroupSpec)

describe(@"WKInterfaceGroup", ^{
    __block WKInterfaceGroup *subject;
    __block GroupController *controller;
    __block PCKInterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[PCKInterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"MyGroupController"
                                                            bundle:[NSBundle buildHelperBundle]];
        subject = controller.group;
    });

    describe(@"setters", ^{
        it(@"should record the sent message for setting the corner radius", ^{
            CGFloat expectedCornerRadius = 7.0f;
            [subject setCornerRadius:expectedCornerRadius];

            subject should have_received(@selector(setCornerRadius:)).with(expectedCornerRadius);
        });

        it(@"should record the sent message for setting the background color", ^{
            UIColor *expectedColor = [UIColor blueColor];
            [subject setBackgroundColor:expectedColor];

            subject should have_received(@selector(setBackgroundColor:)).with([UIColor blueColor]);
        });

        it(@"should record the sent message for setting the background image", ^{
            UIImage *expectedImage = [UIImage imageNamed:@"corgi.jpeg"];
            [subject setBackgroundImage:expectedImage];

            subject should have_received(@selector(setBackgroundImage:)).with([UIImage imageNamed:@"corgi.jpeg"]);
        });

        it(@"should record the sent message for setting the background image with given image data", ^{
            NSData *expectedImageData = [@"asdf" dataUsingEncoding:NSUTF8StringEncoding];
            [subject setBackgroundImageData:expectedImageData];

            subject should have_received(@selector(setBackgroundImageData:)).with([@"asdf" dataUsingEncoding:NSUTF8StringEncoding]);
        });

        it(@"should record the sent message for setting the background image with given image name", ^{
            [subject setBackgroundImageNamed:@"my_special_image.jpg"];

            subject should have_received(@selector(setBackgroundImageNamed:)).with(@"my_special_image.jpg");
        });

        it(@"should record the sent message for starting the animation", ^{
            [subject startAnimating];

            subject should have_received(@selector(startAnimating));
        });

        it(@"should record the sent message for starting the animation with images in range with duration and repeat count", ^{
            NSRange expectedRange = NSMakeRange(0, 2);
            NSTimeInterval expectedDuration = 5;
            [subject startAnimatingWithImagesInRange:expectedRange
                                            duration:expectedDuration
                                         repeatCount:3];

            subject should have_received(@selector(startAnimatingWithImagesInRange:duration:repeatCount:)).with(NSMakeRange(0, 2), expectedDuration, 3);
        });

        it(@"should record the sent message for stopping the animation", ^{
            [subject stopAnimating];

            subject should have_received(@selector(stopAnimating));
        });
    });
});

SPEC_END
