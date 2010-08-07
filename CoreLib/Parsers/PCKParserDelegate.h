#import <Foundation/Foundation.h>

@protocol PCKParserDelegate

- (void)didStartElement:(const char *)elementName;
- (void)didEndElement:(const char *)elementName;
- (void)didFindCharacters:(const char *)characters length:(size_t)length;

@end
