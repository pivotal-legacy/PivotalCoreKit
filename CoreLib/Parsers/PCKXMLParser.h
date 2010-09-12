#import <Foundation/Foundation.h>
#import "PCKParser.h"

// This parser uses libxml, so the implementation must be able to find and
// access the libxml headers and libraries.  You should add  /usr/include/libxml2
// to your header search paths (HEADER_SEARCH_PATHS) under build settings, and
// link against the libxml2.dylib shared library (should be available in the list
// of shared libraries for the SDK you've targeted).

@protocol PCKXMLParser
- (void)didStartElement:(const char *)elementName;
- (void)didEndElement:(const char *)elementName;
- (void)didFindCharacters:(const char *)characters;
@end

typedef void (^PCKParserBlock)(const char *);

@interface PCKXMLParser : NSObject<PCKParser>

@property (nonatomic, copy) PCKParserBlock didStartElement, didEndElement, didFindCharacters;

- (void)parseChunk:(NSData *)chunk;

@end
