#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "PCKXMLParser.h"
#import "PCKXMLParserDelegate.h"

SPEC_BEGIN(PCKXMLParserSpec)

NSString *xml = @""
"<foo>\n"
"  <bar>123</bar>\n"
"  <bat>\n"
"    <wibble>ABC</wibble>\n"
"  </bat>\n"
"  <bat>\n"
"    <wobble>XYZ</wobble>\n"
"  </bat>\n"
"</foo>";

describe(@"PCKXMLParser and PCKXMLParserDelegate", ^{
    __block PCKXMLParser *parser;
    __block PCKXMLParserDelegate *delegate;

    beforeEach(^{
        delegate = [[PCKXMLParserDelegate alloc] init];
        parser = [[PCKXMLParser alloc] initWithDelegate:delegate];
    });

    afterEach(^{
        [parser release];
        [delegate release];
    });

    describe(@"parse", ^{
        __block NSData *data;

        describe(@"with valid XML", ^{
            beforeEach(^{
                data = [xml dataUsingEncoding:NSUTF8StringEncoding];
            });

            describe(@"with no blocks specified on the delegate", ^{
                it(@"should execute the parse without crashing", ^{
                    [parser parseChunk:data];
                });
            });

            describe(@"with a didStartElement block specified on the delegate", ^{
                __block size_t elementCount;
                __block size_t batCount;

                beforeEach(^{
                    delegate.didStartElement = ^(const char *elementName) {
                        if (0 == strncmp(elementName, "bat", strlen(elementName))) {
                            ++batCount;
                        }
                        ++elementCount;
                    };

                    elementCount = batCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(elementCount, equalToInt(6));
                    assertThatInt(batCount, equalToInt(2));
                });
            });

            describe(@"with a didEndElement block specified on the delegate", ^{
                __block size_t elementCount;
                __block size_t batCount;

                beforeEach(^{
                    delegate.didEndElement = ^(const char *elementName) {
                        if (0 == strncmp(elementName, "bat", strlen(elementName))) {
                            ++batCount;
                        }
                        ++elementCount;
                    };

                    elementCount = batCount = 0;
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(elementCount, equalToInt(6));
                    assertThatInt(batCount, equalToInt(2));
                });
            });

            describe(@"with a didFindCharacters block specified on the delegate", ^{
                __block NSMutableString *wibbleContent;

                beforeEach(^{
                    wibbleContent = [[NSMutableString alloc] init];
                    __block BOOL inWibbleElement = NO;

                    delegate.didStartElement = ^(const char *elementName) {
                        if (0 == strncmp(elementName, "wibble", strlen(elementName))) {
                            inWibbleElement = YES;
                        }
                    };

                    delegate.didEndElement = ^(const char *elementName) {
                        if (0 == strncmp(elementName, "wibble", strlen(elementName))) {
                            inWibbleElement = NO;
                        }
                    };

                    delegate.didFindCharacters = ^(const char *chars) {
                        if (inWibbleElement) {
                            NSString *charsObject = [[NSString alloc] initWithCString:chars encoding:NSUTF8StringEncoding];
                            [wibbleContent appendString:charsObject];
                            [charsObject release];
                        }
                    };

                    [parser parseChunk:data];
                });

                afterEach(^{
                    [wibbleContent release];
                });

                it(@"should parse the wibble content", ^{
                    assertThat(wibbleContent, equalTo(@"ABC"));
                });
            });
        });

        describe(@"with XML with attributes", ^{
            NSString * xmlWithAttributes = @"<foo bar=\"baz\" quux=\"zxzzy\"></foo>";

            beforeEach(^{
                data = [xmlWithAttributes dataUsingEncoding:NSUTF8StringEncoding];
            });

            describe(@"with a didStartElementWithAttributes block specified on the delegate", ^{
                __block size_t fooCount;
                __block NSDictionary * attributes;

                beforeEach(^{
                    delegate.didStartElementWithAttributes = ^(const char *elementName, NSDictionary * theAttributes) {
                        if (0 == strncmp(elementName, "foo", strlen(elementName))) {
                            ++fooCount;
                            attributes = [theAttributes copy];
                        }
                    };

                    fooCount = 0;
                    attributes = [NSMutableDictionary dictionary];
                    [parser parseChunk:data];
                });

                it(@"should execute the block appropriately", ^{
                    assertThatInt(fooCount, equalToInt(1));
                    assertThat([attributes valueForKey:@"bar"], equalTo(@"baz"));
                    assertThat([attributes valueForKey:@"quux"], equalTo(@"zxzzy"));
                });
            });
        });

        describe(@"with invalid XML", ^{
            NSString *invalidXML = @"<foo><bar></foo>";

            beforeEach(^{
                data = [invalidXML dataUsingEncoding:NSUTF8StringEncoding];
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
