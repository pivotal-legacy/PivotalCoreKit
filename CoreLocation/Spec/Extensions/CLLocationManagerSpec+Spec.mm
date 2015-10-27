#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif
#import "CLLocationManager+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CLLocationManagerSpec)

describe(@"CLLocationManager", ^{
    describe(@"overriding the authorization status", ^{
        beforeEach(^{
            // It is impossible to set the status to restricted on the simulator.
            [CLLocationManager authorizationStatus] should_not equal(kCLAuthorizationStatusRestricted);

            [CLLocationManager setAuthorizationStatus:kCLAuthorizationStatusRestricted];
        });

        it(@"should return the newly set status", ^{
            [CLLocationManager authorizationStatus] should equal(kCLAuthorizationStatusRestricted);
        });
    });
});

SPEC_END
