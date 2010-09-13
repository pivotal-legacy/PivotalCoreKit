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
    __block NSData *data;

    beforeEach(^{
        delegate = [[PCKXMLParserDelegate alloc] init];
        parser = [[PCKXMLParser alloc] initWithDelegate:delegate];
        data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    });

    afterEach(^{
        [parser release];
        [delegate release];
    });

    describe(@"parse", ^{
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
});

SPEC_END
