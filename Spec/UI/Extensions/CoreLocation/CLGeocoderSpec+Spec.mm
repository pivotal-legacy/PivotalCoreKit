#import "SpecHelper.h"
#import "CLGeocoder+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CLGeocoderSpec)

describe(@"CLGeocoder Spec extension", ^{
    __block CLGeocoder *geocoder;
    NSString *addressString = @"123 Main St.";

    beforeEach(^{
        geocoder = [[[CLGeocoder alloc] init] autorelease];
    });

    describe(@"on init", ^{
        it(@"should not be geocoding", ^{
            geocoder.geocoding should_not be_truthy;
        });
    });

    describe(@"geocodeAddressString:inRegion:completionHandler:", ^{
        beforeEach(^{
            [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:nil];
        });

        it(@"should be geocoding", ^{
            geocoder.geocoding should be_truthy;
        });
    });

    describe(@"cancelGeocode", ^{
        beforeEach(^{
            [geocoder geocodeAddressString:addressString inRegion:nil completionHandler:nil];
            [geocoder cancelGeocode];
        });

        it(@"should stop geocoding", ^{
            geocoder.geocoding should_not be_truthy;
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

            it(@"should no longer be geocoding", ^{
                geocoder.geocoding should_not be_truthy;
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

            it(@"should no longer be geocoding", ^{
                geocoder.geocoding should_not be_truthy;
            });
        });
    });
});

SPEC_END
