#import <Foundation/Foundation.h>
// To include this file you must add /usr/include/libxml2 to your header search
// paths (HEADER_SEARCH_PATHS) under build settings.  Also, link against the
// libxml2.dylib shared library (should be available in the list of shared
// libraries for the SDK you've targeted).
#import <libxml/tree.h>

// TODO: consider passing C strings, rather than incurring the NSString allocation overhead in
// every callback.

typedef void (^PCKParserBlock)(NSString *);

@interface PCKXMLParser : NSObject

@property (nonatomic, copy) PCKParserBlock didStartElement, didEndElement, didFindCharacters;

- (void)parseChunk:(NSData *)chunk;

@end
