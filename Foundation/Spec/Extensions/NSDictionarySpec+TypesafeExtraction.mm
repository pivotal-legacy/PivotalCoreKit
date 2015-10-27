#import "NSDictionary+TypesafeExtraction.h"

#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSDictionary_TypesafeExtraction)

describe(@"NSDictionarySpec_TypesafeExtraction", ^{
    NSString *string = @"abc";
    NSNumber *number = @(123.456);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:123];
    NSString *dateString = @"1/1/1970";
    NSArray *array = @[string, number];
    NSDictionary *dictionary = @{ string: number };
    NSString *URLString = @"/abc/123";
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dict = @{
                           @"string": string,
                           @"number": number,
                           @"number_string": [number stringValue],
                           @"date": date,
                           @"date_string": dateString,
                           @"array": array,
                           @"dict": dictionary,
                           @"url": URL,
                           @"url_string": URLString,
                           @"data": data,
                           @"bool": @(YES)
                           };

    describe(@"extracting typed objects", ^{
        it(@"should return objects which match the requested type", ^{
            [dict objectForKey:@"string" requiredType:[NSString class]] should be_same_instance_as(string);
        });
        it(@"should return nil for objects that don't match the requested type", ^{
            [dict objectForKey:@"string" requiredType:[NSNumber class]] should be_nil;
        });
    });

    describe(@"extracting strings", ^{
        it(@"should return string objects", ^{
            [dict stringObjectForKey:@"string"] should be_same_instance_as(string);
        });
        it(@"should not return other types", ^{
            [dict stringObjectForKey:@"number"] should be_nil;
        });
    });

    describe(@"extracting numbers", ^{
        it(@"should return number objects", ^{
            [dict numberObjectForKey:@"number"] should be_same_instance_as(number);
        });
        it(@"should return number objects from strings representing numbers", ^{
            [dict numberObjectForKey:@"number_string"] should equal(number);
        });
        it(@"should not return other types", ^{
            [dict numberObjectForKey:@"array"] should be_nil;
        });
    });

    describe(@"extracting dates", ^{
        context(@"without a formatter", ^{
            it(@"should return date objects", ^{
                [dict dateObjectForKey:@"date"] should be_same_instance_as(date);
            });
            it(@"should return date objects from numbers representing Unix timestamps", ^{
                [dict dateObjectForKey:@"number"] should equal([NSDate dateWithTimeIntervalSince1970:[number doubleValue]]);
            });
            it(@"should not return other types", ^{
                [dict dateObjectForKey:@"array"] should be_nil;
            });
        });

        context(@"with a formatter", ^{
            it(@"should return date objects", ^{
                [dict dateObjectForKey:@"date"] should be_same_instance_as(date);
            });
            it(@"should return date objects from strings that the formatter can parse", ^{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                [dict dateObjectForKey:@"date_string" formatter:formatter] should equal([NSDate dateWithTimeIntervalSince1970:0]);
            });
            it(@"should not return other types", ^{
                [dict dateObjectForKey:@"string"] should be_nil;
            });
        });
    });

    describe(@"extracting arrays", ^{
        it(@"should return array objects", ^{
            [dict arrayObjectForKey:@"array"] should be_same_instance_as(array);
        });
        it(@"should not return other types", ^{
            [dict arrayObjectForKey:@"string"] should be_nil;
        });

        describe(@"filtering elements by class", ^{
            it(@"should return array objects containing only elements of the given class", ^{
                [dict arrayObjectForKey:@"array" constrainedToElementsOfClass:[NSString class]] should equal(@[string]);
            });
        });
    });

    describe(@"extracting dictionaries", ^{
        it(@"should return dictionary objects", ^{
            [dict dictionaryObjectForKey:@"dict"] should be_same_instance_as(dictionary);
        });
        it(@"should not return other types", ^{
            [dict dictionaryObjectForKey:@"string"] should be_nil;
        });
    });

    describe(@"extracting URLs", ^{
        it(@"should return URL objects", ^{
            [dict URLObjectForKey:@"url"] should be_same_instance_as(URL);
        });
        it(@"should return URL objects from strings representing URLs", ^{
            [dict URLObjectForKey:@"url_string"] should equal([NSURL URLWithString:URLString]);
        });
        it(@"should not return other types", ^{
            [dict URLObjectForKey:@"number"] should be_nil;
        });
    });

    describe(@"extracting floats", ^{
        it(@"should return float values", ^{
            [dict floatValueForKey:@"number"] should equal([number floatValue]);
        });
        it(@"should return float values from strings representing numbers", ^{
            [dict floatValueForKey:@"number_string"] should equal([number floatValue]);
        });
        it(@"should return 0 for other types", ^{
            [dict floatValueForKey:@"string"] should equal(0.0f);
        });
    });

    describe(@"extracting integers", ^{
        it(@"should return integer values", ^{
            [dict integerValueForKey:@"number"] should equal([number integerValue]);
        });
        it(@"should return integer values from strings representing numbers", ^{
            [dict integerValueForKey:@"number_string"] should equal([number integerValue]);
        });
        it(@"should return 0 for other types", ^{
            [dict integerValueForKey:@"string"] should equal(0);
        });
    });

    describe(@"extracting bools", ^{
        it(@"should return bool values", ^{
            [dict boolValueForKey:@"bool"] should equal(YES);
        });
        it(@"should return 0 for other types", ^{
            [dict boolValueForKey:@"string"] should equal(NO);
        });
    });
});

SPEC_END
