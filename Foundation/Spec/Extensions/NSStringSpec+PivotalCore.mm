#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSString+PivotalCore.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(NSString_PivotalCore)

describe(@"Pivotal Core extensions to NSString", ^{
    describe(@"stringByCamelizing", ^{
        it(@"should camelize a underscored string", ^{
            NSString *camelizedString = [@"foo_bar_baz" stringByCamelizing];
            expect(camelizedString).to(equal(@"fooBarBaz"));
        });
    });

    describe(@"endsWith:", ^{
        NSString *receiver = @"A string that ends with another";
        __block NSString *substring;

        __block BOOL endsWith;
        subjectAction(^{ endsWith = [receiver endsWith:substring]; });

        beforeEach(^{
            endsWith = NO;
        });

        context(@"when the receiver ends with the passed argument", ^{
            beforeEach(^{
                substring = @"with another";
            });

            it(@"should be true", ^{
                endsWith should be_truthy;
            });
        });

        context(@"when the receiver does not end with the passed argument", ^{
            beforeEach(^{
                substring = @"something strange";
            });

            it(@"should not be true", ^{
                endsWith should_not be_truthy;
            });
        });

        context(@"when the strings have the same value", ^{
            beforeEach(^{
                substring = [[receiver copy] autorelease];
            });

            it(@"should be true", ^{
                endsWith should be_truthy;
            });
        });

        context(@"when the string is a substring that doesn't go to the end", ^{
            beforeEach(^{
                substring = @"that ends with";
            });

            it(@"should not be true", ^{
                endsWith should_not be_truthy;
            });
        });

        context(@"with a string that matches the beginning", ^{
            beforeEach(^{
                substring = @"A string";
            });

            it(@"should not be true", ^{
                endsWith should_not be_truthy;
            });
        });

        context(@"with a totally different string", ^{
            beforeEach(^{
                substring = @"totally different";
            });

            it(@"should not be true", ^{
                endsWith should_not be_truthy;
            });
        });
    });

    describe(@"initWithBase64EncodedData:", ^{
        __block NSString *newString;

        describe(@"with 20 bytes of blank data", ^{
            beforeEach(^{
                char bytes[20];
                memset(bytes, 0, 20);

                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:20]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@"AAAAAAAAAAAAAAAAAAAAAAAAAAA="));
            });
        });

        describe(@"with 20 bytes of non-blank data", ^{
            beforeEach(^{
                const char bytes[20] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't'};
                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:20]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@"YWJjZGVmZ2hpamtsbW5vcHFyc3Q="));
            });
        });

        describe(@"with 0 bytes of data", ^{
            beforeEach(^{
                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData data]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@""));
            });
        });

        describe(@"with 1 byte of data", ^{
            beforeEach(^{
                const char bytes[1] = {'A'};
                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:1]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@"QQ=="));
            });
        });

        describe(@"with 2 bytes of data", ^{
            beforeEach(^{
                const char bytes[2] = {'A', 'B'};
                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:2]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@"QUI="));
            });
        });

        describe(@"with 3 bytes of data", ^{
            beforeEach(^{
                const char bytes[3] = {'A', 'B', 'C'};
                newString = [[[NSString alloc] initWithBase64EncodedData:[NSData dataWithBytes:bytes length:3]] autorelease];
            });

            it(@"should create a correctly base-64 encoded string", ^{
                expect(newString).to(equal(@"QUJD"));
            });
        });
    });

    static const NSString *ALL_INVALID_URL_CHARACTERS[] = {
        @" ", @"\"", @"#", @"$", @"%", @"&", @"+", @",",
        @"/", @":", @";", @"<", @"=", @">", @"?", @"@",
        @"[", @"\\", @"]", @"^", @"`", @"{", @"|", @"}", @"~"
    };

    static const NSString *ALL_ESCAPED_URL_CHARACTERS[] = {
        @"%20", @"%22", @"%23", @"%24", @"%25", @"%26", @"%2B", @"%2C",
        @"%2F", @"%3A", @"%3B", @"%3C", @"%3D", @"%3E", @"%3F", @"%40",
        @"%5B", @"%5C", @"%5D", @"%5E", @"%60", @"%7B", @"%7C", @"%7D", @"%7E"
    };

    static const NSString *DEFAULT_INVALID_URL_CHARACTERS[] = {
        @" ", @"\"", @"#", @"$", @"%", @"&", @"+", @",",
        @"/", @":", @";", @"<", @"=", @">", @"?", @"@",
        @"[", @"\\", @"]", @"^", @"`", @"{", @"|", @"}", @"~"
    };

    static const NSString *DEFAULT_ESCAPED_URL_CHARACTERS[] = {
        @"%20", @"%22", @"%23", @"$", @"%25", @"&", @"+", @",",
        @"/", @":", @";", @"%3C", @"=", @"%3E", @"?", @"@",
        @"%5B", @"%5C", @"%5D", @"%5E", @"%60", @"%7B", @"%7C", @"%7D", @"~"
    };

    describe(@"stringByAddingPercentEscapesUsingEncoding:includeAll:", ^{
        describe(@"with includeAll set to YES", ^{
            size_t invalidCount = sizeof(ALL_INVALID_URL_CHARACTERS) / sizeof(NSString *);
            size_t escapedCount = sizeof(ALL_ESCAPED_URL_CHARACTERS) / sizeof(NSString *);

            it(@"should escape all invalid URL characters, including slashes and question marks", ^{
                expect(invalidCount).to(equal(escapedCount));

                for (unsigned int i = 0; i != invalidCount; ++i) {
                    NSString *stringWithInvalidCharacter = [NSString stringWithFormat:@"foo%@bar", ALL_INVALID_URL_CHARACTERS[i]];
                    NSString *stringWithEscapedCharacter = [NSString stringWithFormat:@"foo%@bar", ALL_ESCAPED_URL_CHARACTERS[i]];

                    NSString *escapedString = [stringWithInvalidCharacter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeAll:YES];
                    expect(escapedString).to(equal(stringWithEscapedCharacter));
                }
            });
        });

        describe(@"with includeAll set to NO", ^{
            size_t invalidCount = sizeof(DEFAULT_INVALID_URL_CHARACTERS) / sizeof(NSString *);
            size_t escapedCount = sizeof(DEFAULT_ESCAPED_URL_CHARACTERS) / sizeof(NSString *);

            it(@"should escape invalid URL characters, not including slashes and question marks (the default Apple-blessed behavior)", ^{
                expect(invalidCount).to(equal(escapedCount));

                for (unsigned int i = 0; i != invalidCount; ++i) {
                    NSString *stringWithInvalidCharacter = [NSString stringWithFormat:@"foo%@bar", DEFAULT_INVALID_URL_CHARACTERS[i]];
                    NSString *stringWithEscapedCharacter = [NSString stringWithFormat:@"foo%@bar", DEFAULT_ESCAPED_URL_CHARACTERS[i]];

                    NSString *escapedString = [stringWithInvalidCharacter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeAll:NO];
                    expect(escapedString).to(equal(stringWithEscapedCharacter));
                }
            });
        });
    });

    describe(@"isBlank", ^{
        it(@"should return YES for strings with nothing but whitespace", ^{
            [@"   " isBlank] should equal(YES);
            [@"  \t\n   " isBlank] should equal(YES);
        });

        it(@"should return YES for an empty string", ^{
            [@"" isBlank] should equal(YES);
        });

        it(@"should return NO for strings with anything but whitespace", ^{
            [@"blankme" isBlank] should equal(NO);
        });
    });

    describe(@"isValidEmailAddress", ^{
        __block NSString *emailAddress;

        context(@"with a valid email address", ^{
            beforeEach(^{
                emailAddress = @"foo@example.com";
            });

            it(@"should be true", ^{
                [emailAddress isValidEmailAddress] should be_truthy;
            });
        });

        context(@"with an invalid email address", ^{
            beforeEach(^{
                emailAddress = @"foo@example";
            });

            it(@"should be false", ^{
                [emailAddress isValidEmailAddress] should_not be_truthy;
            });
        });
    });
});

SPEC_END
