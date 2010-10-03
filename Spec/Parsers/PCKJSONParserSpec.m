#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "PCKJSONParser.h"
#import "PCKJSONParserDelegate.h"

SPEC_BEGIN(PCKJSONParserSpec)

NSString *json = @"{"
"  \"foo\":{\n"
"    \"bar\":123,\n"
"    \"bats\":[{\n"
"      \"wibble\":\"ABC\"\n"
"    },{\n"
"      \"wibble\":\"XYZ\"\n"
"    },\n"
"    1]\n"
"  }"
"}";

describe(@"PCKJSONParser and PCKJSONParserDelegate", ^{
    __block PCKJSONParser *parser;
    __block PCKJSONParserDelegate *delegate;

    beforeEach(^{
        delegate = [[PCKJSONParserDelegate alloc] init];
        parser = [[PCKJSONParser alloc] initWithDelegate:delegate];
    });

    afterEach(^{
        [parser release];
        [delegate release];
    });

    describe(@"parse", ^{
        __block NSData *data;

        describe(@"with valid JSON", ^{
            beforeEach(^{
                data = [json dataUsingEncoding:NSUTF8StringEncoding];
            });

            describe(@"with no blocks specified on the delegate", ^{
                it(@"should execute the parse without crashing", ^{
                    [parser parseChunk:data];
                });
            });

            describe(@"with a didStartDictionary block specified", ^{
                __block size_t objectCount;

                beforeEach(^{
                    delegate.didStartDictionary = ^{
                        ++objectCount;
                    };
                    objectCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(objectCount, equalToInt(4));
                });
            });

            describe(@"with a didEndDictionary block specified", ^{
                __block size_t objectCount;

                beforeEach(^{
                    delegate.didEndDictionary = ^{
                        ++objectCount;
                    };
                    objectCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(objectCount, equalToInt(4));
                });
            });

            describe(@"with a didStartArray block specified", ^{
                __block size_t arrayCount;

                beforeEach(^{
                    delegate.didStartArray = ^{
                        ++arrayCount;
                    };
                    arrayCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(arrayCount, equalToInt(1));
                });
            });

            describe(@"with a didEndArray block specified", ^{
                __block size_t arrayCount;

                beforeEach(^{
                    delegate.didEndArray = ^{
                        ++arrayCount;
                    };
                    arrayCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(arrayCount, equalToInt(1));
                });
            });

            describe(@"with a didFindKey block specified", ^{
                __block size_t wibbleCount;

                beforeEach(^{
                    delegate.didFindKey = ^(NSString *key) {
                        if ([key isEqualToString:@"wibble"]) {
                            ++wibbleCount;
                        }
                    };
                    wibbleCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(wibbleCount, equalToInt(2));
                });
            });

            describe(@"with a didFindValue block specified", ^{
                __block size_t abcCount, xyzCount;

                beforeEach(^{
                    delegate.didFindValue = ^(id value) {
                        if ([value isEqualTo:@"ABC"]) {
                            ++abcCount;
                        } else if ([value isEqualTo:@"XYZ"]) {
                            ++xyzCount;
                        }
                    };
                    abcCount = xyzCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(abcCount, equalToInt(1));
                    assertThatInt(xyzCount, equalToInt(1));
                });
            });
        });

        describe(@"with invalid JSON", ^{
            NSString *invalidJSON = @"invalid JSON";

            beforeEach(^{
                data = [invalidJSON dataUsingEncoding:NSUTF8StringEncoding];
            });

            describe(@"with no error block set", ^{
                it(@"should execute the parse without crashing", ^{
                    [parser parseChunk:data];
                });
            });

            describe(@"with an error block set on the delegate", ^{
                __block NSError *encounteredError;

                beforeEach(^{
                    delegate.didEncounterError = ^(NSError *error) {
                        encounteredError = error;
                    };
                    encounteredError = nil;
                    [parser parseChunk:data];
                });

                it(@"should execute the error block, passing a valid NSError object to the delegate", ^{
                    assertThat(encounteredError, notNilValue());
                    assertThat([encounteredError class], equalTo([NSError class]));
                });
            });
        });
    });
});

SPEC_END
