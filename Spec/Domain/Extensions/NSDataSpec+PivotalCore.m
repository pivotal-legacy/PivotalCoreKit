#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSData+PivotalCore.h"

SPEC_BEGIN(NSData_PivotalCore)

describe(@"Pivotal Core extensions to NSData ", ^{
    describe(@"initWithSHA1HashOfString:", ^{
        __block NSData *newData;

        afterEach(^{
            [newData release];
        });

        describe(@"with an empty string", ^{
            beforeEach(^{
                newData = [[NSData alloc] initWithSHA1HashOfString:@""];
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                assertThat([newData description], equalTo(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });

        describe(@"with a non-empty string", ^{
            beforeEach(^{
                newData = [[NSData alloc] initWithSHA1HashOfString:@"wibble"];
            });

            it(@"should initialize with the correct SHA1 hash data", ^{
                assertThat([newData description], equalTo(@"<02e0182a e38f90d1 1be647e3 37665e67 f9243817>"));
            });
        });

        describe(@"with a nil string parameter", ^{
            beforeEach(^{
                newData = [[NSData alloc] initWithSHA1HashOfString:nil];
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                assertThat([newData description], equalTo(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });
    });
});

SPEC_END
