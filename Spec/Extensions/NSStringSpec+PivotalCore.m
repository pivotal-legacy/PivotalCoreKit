#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSString+PivotalCore.h"

SPEC_BEGIN(NSString_PivotalCore)

describe(@"Pivotal Core extensions to NSString", ^{
    describe(@"initWithBase64EncodedData:", ^{
        __block NSString *newString = nil;

        afterEach(^{
            [newString release];
        });

        describe(@"with 20 bytes of blank data", ^{
            beforeEach(^{
                char bytes[20];
                for (int i = 0; i < 20; ++i) {
                    bytes[i] = 0;
                }
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:20]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@"AAAAAAAAAAAAAAAAAAAAAAAAAAA="));
            });
        });

        describe(@"with 20 bytes of non-blank data", ^{
            beforeEach(^{
                const char bytes[20] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't'};
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:20]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@"YWJjZGVmZ2hpamtsbW5vcHFyc3Q="));
            });
        });

        describe(@"with 0 bytes of data", ^{
            beforeEach(^{
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData data]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@""));
            });
        });

        describe(@"with 1 byte of data", ^{
            beforeEach(^{
                const char bytes[1] = {'A'};
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:1]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@"QQ=="));
            });
        });

        describe(@"with 2 bytes of data", ^{
            beforeEach(^{
                const char bytes[2] = {'A', 'B'};
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:2]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@"QUI="));
            });
        });

        describe(@"with 3 bytes of data", ^{
            beforeEach(^{
                const char bytes[3] = {'A', 'B', 'C'};
                newString = [[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:3]];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                assertThat(newString, equalTo(@"QUJD"));
            });
        });
    });
});

SPEC_END
