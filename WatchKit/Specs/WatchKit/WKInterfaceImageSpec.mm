#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceImageSpec)

describe(@"WKInterfaceImage", ^{
    __block WKInterfaceImage *subject;

    beforeEach(^{
        subject = [[WKInterfaceImage alloc] init];
    });

    describe(@"setters", ^{

        it(@"should record the invocation for setImage:", ^{
            UIImage *image = [[UIImage alloc] init];
            [subject setImage:image];
            subject should have_received(@selector(setImage:)).with(image);
        });

        it(@"should record the invocation for setImageData:", ^{
            NSData *data = [[NSData alloc] init];
            [subject setImageData:data];
            subject should have_received(@selector(setImageData:)).with(data);
        });

        it(@"should record the invocation for setImageNamed:", ^{
            [subject setImageNamed:@"asdf"];
            subject should have_received(@selector(setImageNamed:)).with(@"asdf");
        });

        it(@"should record the sent message for startAnimating", ^{
            [subject startAnimating];

            subject should have_received(@selector(startAnimating));
        });

        it(@"should record the sent message for startAnimatingWithImagesInRange:duration:repeatCount:", ^{
            NSRange expectedRange = NSMakeRange(0, 2);
            NSTimeInterval expectedDuration = 5;
            [subject startAnimatingWithImagesInRange:expectedRange
                                            duration:expectedDuration
                                         repeatCount:3];

            subject should have_received(@selector(startAnimatingWithImagesInRange:duration:repeatCount:)).with(NSMakeRange(0, 2), expectedDuration, 3);
        });

        it(@"should record the sent message for stopAnimating", ^{
            [subject stopAnimating];

            subject should have_received(@selector(stopAnimating));
        });

        it(@"should record the invocation for setTintColor:", ^{
            [subject setTintColor:[UIColor clearColor]];

            subject should have_received(@selector(setTintColor:)).with([UIColor clearColor]);
        });
    });
});

SPEC_END
