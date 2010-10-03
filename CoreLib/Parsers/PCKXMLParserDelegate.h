#import <Foundation/Foundation.h>
#import "PCKParserDelegate.h"

@class PCKXMLParser;

@protocol PCKXMLParserDelegate <PCKParserDelegate>
- (void)parser:(PCKXMLParser *)parser didStartElement:(const char *)elementName;
- (void)parser:(PCKXMLParser *)parser didEndElement:(const char *)elementName;
- (void)parser:(PCKXMLParser *)parser didFindCharacters:(const char *)characters;
@end

typedef void (^PCKXMLParserDelegateBlock)(const char *);

@interface PCKXMLParserDelegate : NSObject <PCKXMLParserDelegate>

@property (nonatomic, copy) PCKXMLParserDelegateBlock didStartElement, didEndElement, didFindCharacters;
@property (nonatomic, copy) PCKParserErrorBlock didEncounterError;

@end
