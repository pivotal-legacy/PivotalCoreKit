#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "NSString+PivotalCore.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(NSString_PivotalCore)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

describe(@"Pivotal Core extensions to NSString", ^{
    describe(@"stringByCamelizing", ^{
        it(@"should camelize a underscored string", ^{
            NSString *camelizedString = [@"foo_bar_baz" stringByCamelizing];
            expect(camelizedString).to(equal(@"fooBarBaz"));
        });
    });

    describe(@"-initWithBase64EncodedData:", ^{
        it(@"continues to base64 encode data", ^{
            const char bytes[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't'};

            NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            NSString *string = [[NSString alloc] initWithBase64EncodedData:data];

            string should equal(@"YWJjZGVmZ2hpamtsbW5vcHFyc3Q=");
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

#pragma clang diagnostic pop

SPEC_END
