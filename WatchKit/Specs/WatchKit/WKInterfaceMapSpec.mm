#import "Cedar.h"
#import "NSBundle+BuildHelper.h"
#import "PCKFixtureMapController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceMapSpec)

describe(@"WKInterfaceMap", ^{
    __block WKInterfaceMap *subject;
    __block PCKFixtureMapController *controller;
    __block PCKInterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[PCKInterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface"
                                                        identifier:@"MyMapController"
                                                            bundle:[NSBundle buildHelperBundle]];
        subject = controller.zebraMap;
    });

    describe(@"setters", ^{
        it(@"should record the sent message for setting the map's visible map rect", ^{
            MKMapRect expectedMapRect = MKMapRectMake(0, 0, 10, 10);
            [subject setVisibleMapRect:expectedMapRect];

            subject should have_received(@selector(setVisibleMapRect:));

            MKMapRect mapRect;
            NSInvocation *invocation = [[(id)subject sent_messages] firstObject];
            [invocation getArgument:&mapRect atIndex:2];
            MKMapRectEqualToRect(mapRect, expectedMapRect) should be_truthy;
        });

        it(@"should record the sent message for setting the map's region", ^{
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.7833, 122.4167);
            MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.3);
            MKCoordinateRegion expectedRegion = MKCoordinateRegionMake(coordinate, span);
            [subject setRegion:expectedRegion];

            subject should have_received(@selector(setRegion:));

            MKCoordinateRegion mapRegion;
            NSInvocation *invocation = [[(id)subject sent_messages] firstObject];
            [invocation getArgument:&mapRegion atIndex:2];
            mapRegion.center.latitude should equal(37.7833);
            mapRegion.center.longitude should equal(122.4167);
            mapRegion.span.latitudeDelta should equal(0.2);
            mapRegion.span.longitudeDelta should equal(0.3);
        });

        it(@"should record the sent message for adding an annotation with an image and center offset", ^{
            CLLocationCoordinate2D expectedCoordinate = CLLocationCoordinate2DMake(37.7833, 122.4167);
            UIImage *expectedImage = [UIImage imageNamed:@"corgi.jpeg"];
            CGPoint expectedOffset = CGPointMake(3, 4);
            [subject addAnnotation:expectedCoordinate withImage:expectedImage centerOffset:expectedOffset];

            subject should have_received(@selector(addAnnotation:withImage:centerOffset:));

            CLLocationCoordinate2D coordinate;
            __autoreleasing UIImage *image;
            CGPoint offset;

            NSInvocation *invocation = [[(id)subject sent_messages] firstObject];
            [invocation getArgument:&coordinate atIndex:2];
            [invocation getArgument:&image atIndex:3];
            [invocation getArgument:&offset atIndex:4];

            coordinate.latitude should equal(37.7833);
            coordinate.longitude should equal(122.4167);
            image should equal(expectedImage);
            offset.x should equal(3);
            offset.y should equal(4);
        });

        it(@"should record the sent message for adding an annotation with an image name and center offset", ^{
            CLLocationCoordinate2D expectedCoordinate = CLLocationCoordinate2DMake(37.7833, 122.4167);
            NSString *expectedImageName = @"corgi.jpeg";
            CGPoint expectedOffset = CGPointMake(3, 4);
            [subject addAnnotation:expectedCoordinate withImageNamed:expectedImageName centerOffset:expectedOffset];

            subject should have_received(@selector(addAnnotation:withImageNamed:centerOffset:));

            CLLocationCoordinate2D coordinate;
            __autoreleasing NSString *imageName;
            CGPoint offset;

            NSInvocation *invocation = [[(id)subject sent_messages] firstObject];
            [invocation getArgument:&coordinate atIndex:2];
            [invocation getArgument:&imageName atIndex:3];
            [invocation getArgument:&offset atIndex:4];

            coordinate.latitude should equal(37.7833);
            coordinate.longitude should equal(122.4167);
            imageName should equal(expectedImageName);
            offset.x should equal(3);
            offset.y should equal(4);
        });

        it(@"should record the sent message for adding an annotation with a pin color", ^{
            CLLocationCoordinate2D expectedCoordinate = CLLocationCoordinate2DMake(37.7833, 122.4167);
            WKInterfaceMapPinColor expectedPinColor = WKInterfaceMapPinColorPurple;

            [subject addAnnotation:expectedCoordinate withPinColor:expectedPinColor];

            subject should have_received(@selector(addAnnotation:withPinColor:));

            CLLocationCoordinate2D coordinate;
            WKInterfaceMapPinColor pinColor;

            NSInvocation *invocation = [[(id)subject sent_messages] firstObject];
            [invocation getArgument:&coordinate atIndex:2];
            [invocation getArgument:&pinColor atIndex:3];

            coordinate.latitude should equal(37.7833);
            coordinate.longitude should equal(122.4167);
            pinColor should equal(expectedPinColor);
        });

        it(@"should record the sent message for removing all annotations", ^{
            [subject removeAllAnnotations];
            subject should have_received(@selector(removeAllAnnotations));
        });
    });
});

SPEC_END
