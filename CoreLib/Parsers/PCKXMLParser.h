#import <Foundation/Foundation.h>
#import "PCKParser.h"
#import "PCKParserDelegate.h"

// This parser uses libxml, so the implementation must be able to find and
// access the libxml headers and libraries.  You should add  /usr/include/libxml2
// to your header search paths (HEADER_SEARCH_PATHS) under build settings, and
// link against the libxml2.dylib shared library (should be available in the list
// of shared libraries for the SDK you've targeted).

typedef void (^PCKParserBlock)(const char *);

@interface PCKXMLParser : NSObject<PCKParser, PCKParserDelegate>

@property (nonatomic, copy) PCKParserBlock didStartElement, didEndElement, didFindCharacters;

- (void)parseChunk:(NSData *)chunk;

@end
