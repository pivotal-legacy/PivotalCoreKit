#import "Cedar.h"
#import "WKExtension.h"
#import "WKExtension+Spec.h"
#import "WKInterfaceController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKExtensionSpec)

describe(@"WKExtension", ^{
    __block WKExtension *subject;

    beforeEach(^{
        subject = [[WKExtension alloc] init];
    });

    describe(@"public methods", ^{
        it(@"should record the invocation for -openSystemURL:", ^{
            NSURL *URL = [NSURL URLWithString:@"http://pivotal.io"];
            [subject openSystemURL:URL];

            subject should have_received(@selector(openSystemURL:)).with(URL);
        });

        it(@"should allow setting and getting the delegate object", ^{
            id<WKExtensionDelegate> delegate = nice_fake_for(@protocol(WKExtensionDelegate));
            subject.delegate = delegate;

            subject.delegate should be_same_instance_as(delegate);
        });

        it(@"should allow setting and getting the rootInterfaceController", ^{
            WKInterfaceController *controller = [[WKInterfaceController alloc] init];
            subject.rootInterfaceController = controller;

            subject.rootInterfaceController should be_same_instance_as(controller);
        });
    });

    describe(@"class methods", ^{
        __block WKExtension *previousSharedExtension;

        it(@"should allow setting and getting the shared extension", ^{
            [WKExtension setSharedExtension:subject];
            [WKExtension sharedExtension] should be_same_instance_as(subject);
        });

        it(@"should generate a WKExtension instance to be the shared extension when none is provided", ^{
            previousSharedExtension = [WKExtension sharedExtension];
            previousSharedExtension  should be_instance_of([WKExtension class]);
            [WKExtension sharedExtension] should be_same_instance_as(previousSharedExtension);
        });

        it(@"should generate a fresh instance for each spec", ^{
            [WKExtension sharedExtension] should_not be_same_instance_as(previousSharedExtension);
        });
    });
});

SPEC_END
