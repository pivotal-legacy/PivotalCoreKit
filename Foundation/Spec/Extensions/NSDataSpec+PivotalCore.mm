#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSData+PivotalCore.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(NSData_PivotalCore)

describe(@"Pivotal Core extensions to NSData ", ^{
    describe(@"initWithSHA1HashOfString:", ^{
        __block NSData *newData;

        describe(@"with an empty string", ^{
            beforeEach(^{
                newData = [[[NSData alloc] initWithSHA1HashOfString:@""] autorelease];
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                NSString *description = newData.description;
                expect(description).to(equal(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });

        describe(@"with a non-empty string", ^{
            beforeEach(^{
                newData = [[[NSData alloc] initWithSHA1HashOfString:@"wibble"] autorelease];
            });

            it(@"should initialize with the correct SHA1 hash data", ^{
                NSString *description = newData.description;
                expect(description).to(equal(@"<02e0182a e38f90d1 1be647e3 37665e67 f9243817>"));
            });
        });

        describe(@"with a nil string parameter", ^{
            beforeEach(^{
                newData = [[[NSData alloc] initWithSHA1HashOfString:nil] autorelease];
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                NSString *description = newData.description;
                expect(description).to(equal(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });
    });
});

SPEC_END
