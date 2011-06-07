#import <Foundation/Foundation.h>
#import "PCKParserDelegate.h"

@class PCKXMLParser;

@protocol PCKXMLParserDelegate <PCKParserDelegate>
- (void)parser:(PCKXMLParser *)parser didStartElement:(const char *)elementName attributeCount:(int)numAttributes attributeData:(const char**)attributes;
- (void)parser:(PCKXMLParser *)parser didEndElement:(const char *)elementName;
- (void)parser:(PCKXMLParser *)parser didFindCharacters:(const char *)characters;
@end

typedef void (^PCKXMLParserDelegateBlock)(const char *);
typedef void (^PCKXMLParserDelegateBlockWithAttributes)(const char *, NSDictionary *);

@interface PCKXMLParserDelegate : NSObject <PCKXMLParserDelegate>

@property (nonatomic, copy) PCKXMLParserDelegateBlock didStartElement, didEndElement, didFindCharacters;
@property (nonatomic, copy) PCKXMLParserDelegateBlockWithAttributes didStartElementWithAttributes;
@property (nonatomic, copy) PCKParserErrorBlock didEncounterError;

@end
