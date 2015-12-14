#import <Foundation/Foundation.h>
#import "PCKParserDelegate.h"

@class PCKXMLParser;

NS_ASSUME_NONNULL_BEGIN

@protocol PCKXMLParserDelegate <PCKParserDelegate>
- (void)parser:(PCKXMLParser *)parser didStartElement:(const char *)elementName attributeCount:(int)numAttributes attributeData:(const char * __nonnull const * __nonnull)attributes;
- (void)parser:(PCKXMLParser *)parser didEndElement:(const char *)elementName;
- (void)parser:(PCKXMLParser *)parser didFindCharacters:(const char *)characters;
@end

typedef void (^PCKXMLParserDelegateBlock)(const char *);
typedef void (^PCKXMLParserDelegateBlockWithAttributes)(const char *, NSDictionary *);

@interface PCKXMLParserDelegate : NSObject <PCKXMLParserDelegate>

@property (nonatomic, copy, nullable) PCKXMLParserDelegateBlock didStartElement, didEndElement, didFindCharacters;
@property (nonatomic, copy, nullable) PCKXMLParserDelegateBlockWithAttributes didStartElementWithAttributes;
@property (nonatomic, copy, nullable) PCKParserErrorBlock didEncounterError;

@end

NS_ASSUME_NONNULL_END
