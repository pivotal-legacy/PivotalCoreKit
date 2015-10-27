#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif
#import "CLGeocoder+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CLGeocoderSpec)

describe(@"CLGeocoder Spec extension", ^{
    __block CLGeocoder *geocoder;
    NSString *addressString = @"123 Main St.";
    CLLocation *location = [[CLLocation alloc] initWithLatitude:44.0 longitude:-122.0];

    beforeEach(^{
        geocoder = [[[CLGeocoder alloc] init] autorelease];
    });

    describe(@"on init", ^{
        it(@"should not be geocoding", ^{
            geocoder.geocoding should_not be_truthy;
        });

        it(@"should have no addressString", ^{
            geocoder.addressString should be_nil;
        });
    });

    describe(@"reverseGeocodeLocation:completionHandler:", ^{
        beforeEach(^{
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){}];
        });

        it(@"should start geocoding", ^{
            geocoder.geocoding should be_truthy;
        });

        it(@"should set location to the specified location", ^{
            geocoder.location should equal(location);
        });
    });

    describe(@"geocodeAddressString:inRegion:completionHandler:", ^{
        beforeEach(^{
            [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error){}];
        });

        it(@"should start geocoding", ^{
            geocoder.geocoding should be_truthy;
        });

        it(@"should set addressString to the specified address", ^{
            geocoder.addressString should equal(addressString);
        });
    });

    describe(@"cancelGeocode", ^{
        beforeEach(^{
            [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error){}];
            [geocoder cancelGeocode];
        });

        it(@"should stop geocoding", ^{
            geocoder.geocoding should_not be_truthy;
        });

        it(@"should reset the address string", ^{
            geocoder.addressString should be_nil;
        });
    });

    describe(@"completeGeocodeWithPlacemarks:", ^{
        NSArray *expectedPlacemarks = [NSArray array];

        context(@"when not geocoding", ^{
            beforeEach(^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should raise an exception", ^{
                ^{ [geocoder completeGeocodeWithPlacemarks:expectedPlacemarks]; } should raise_exception;
            });
        });

        context(@"when geocoding", ^{
            __block CLGeocodeCompletionHandler completionHandler;
            __block BOOL receivedPlacemarks = NO;

            beforeEach(^{
                completionHandler = ^(NSArray *placemarks, NSError *error) {
                    if (placemarks == expectedPlacemarks) {
                        receivedPlacemarks = YES;
                    }
                };

                [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:completionHandler];
                [geocoder completeGeocodeWithPlacemarks:expectedPlacemarks];
            });

            it(@"should send the placemarks to the specified completion block", ^{
                receivedPlacemarks should be_truthy;
            });

            it(@"should stop geocoding", ^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should reset the address string", ^{
                geocoder.addressString should be_nil;
            });
        });
    });

    describe(@"completeReverseGeocodeWithPlacemarks:", ^{
        NSArray *expectedPlacemarks = [NSArray array];

        context(@"when not geocoding", ^{
            beforeEach(^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should raise an exception", ^{
                ^{ [geocoder completeReverseGeocodeWithPlacemarks:expectedPlacemarks]; } should raise_exception;
            });
        });

        context(@"when geocoding", ^{
            __block CLGeocodeCompletionHandler completionHandler;
            __block BOOL receivedPlacemarks = NO;

            beforeEach(^{
                completionHandler = ^(NSArray *placemarks, NSError *error) {
                    if (placemarks == expectedPlacemarks) {
                        receivedPlacemarks = YES;
                    }
                };

                [geocoder reverseGeocodeLocation:location completionHandler:completionHandler];
                [geocoder completeReverseGeocodeWithPlacemarks:expectedPlacemarks];
            });

            it(@"should send the placemarks to the specified completion block", ^{
                receivedPlacemarks should be_truthy;
            });

            it(@"should stop geocoding", ^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should reset the location", ^{
                geocoder.location should be_nil;
            });
        });
    });

    describe(@"completeGeocodeWithError:", ^{
        NSError *expectedError = [NSError errorWithDomain:@"Bad!" code:2 userInfo:nil];

        context(@"when not geocoding", ^{
            beforeEach(^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should raise an exception", ^{
                ^{ [geocoder completeGeocodeWithError:expectedError]; } should raise_exception;
            });
        });

        context(@"when geocoding", ^{
            __block CLGeocodeCompletionHandler completionHandler;
            __block BOOL receivedError = NO;

            beforeEach(^{
                completionHandler = ^(NSArray *placemarks, NSError *error) {
                    if (error == expectedError && !placemarks) {
                        receivedError = YES;
                    }
                };

                [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:completionHandler];
                [geocoder completeGeocodeWithError:expectedError];
            });

            it(@"should send the error to the specified completion block", ^{
                receivedError should be_truthy;
            });

            it(@"should stop geocoding", ^{
                geocoder.geocoding should_not be_truthy;
            });

            it(@"should reset the address string", ^{
                geocoder.addressString should be_nil;
            });
        });
    });
});

SPEC_END
