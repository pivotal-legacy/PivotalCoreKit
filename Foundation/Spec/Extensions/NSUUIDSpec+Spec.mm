#import <Foundation/Foundation.h>
#import "NSUUID+Spec.h"

#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif
using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSUUIDSpec_Spec)

describe(@"NSUUID (spec extensions)", ^{
    describe(@"logging the generated uuids", ^{
        it(@"saves off the generated UUIDs to an accessible array", ^{
            NSUUID.generatedUUIDs.count should equal(0);
            NSUUID *firstUUID = [NSUUID UUID];
            firstUUID should_not be_nil;

            NSUUID.generatedUUIDs.count should equal(1);
            NSUUID.generatedUUIDs[0] should equal(firstUUID);
            NSUUID *secondUUID = [NSUUID UUID];
            NSUUID.generatedUUIDs.count should equal(2);
            NSUUID.generatedUUIDs[1] should equal(secondUUID);
        });
    });

    describe(@"resetting", ^{
        it(@"resets the stored UUIDs", ^{
            [NSUUID UUID];
            [NSUUID UUID];
            NSUUID.generatedUUIDs.count should equal(2);
            [NSUUID reset];
            NSUUID.generatedUUIDs.count should equal(0);
        });
    });

    describe(@"test pollution", ^{
        it(@"should not pollute your tests", ^{
            [NSUUID UUID];
            NSUUID.generatedUUIDs.count should equal(1);
        });

        it(@"really should not pollute your tests", ^{
            [NSUUID UUID];
            NSUUID.generatedUUIDs.count should equal(1);
        });
    });
});

SPEC_END
