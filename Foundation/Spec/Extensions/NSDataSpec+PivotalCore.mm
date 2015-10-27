#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "NSData+PivotalCore.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(NSData_PivotalCore)

describe(@"Pivotal Core extensions to NSData ", ^{
    describe(@"initWithSHA1HashOfString:", ^{
        __block NSData *newData;
        __block NSString *string;

        subjectAction(^{ newData = [[NSData alloc] initWithSHA1HashOfString:string]; });

        describe(@"with an empty string", ^{
            beforeEach(^{
                string = @"";
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                expect(newData.description).to(equal(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });

        describe(@"with a non-empty string", ^{
            beforeEach(^{
                string = @"wibble";
            });

            it(@"should initialize with the correct SHA1 hash data", ^{
                expect(newData.description).to(equal(@"<02e0182a e38f90d1 1be647e3 37665e67 f9243817>"));
            });
        });

        describe(@"with a nil string parameter", ^{
            beforeEach(^{
                string = nil;
            });

            it(@"should initialize with the SHA1 hash of an empty string", ^{
                expect(newData.description).to(equal(@"<da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709>"));
            });
        });
    });
});

SPEC_END
