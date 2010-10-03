#import <Foundation/Foundation.h>
#import "PCKParserDelegate.h"

@class PCKJSONParser;

@protocol PCKJSONParserDelegate <PCKParserDelegate>
- (void)parserDidStartDictionary:(PCKJSONParser *)parser;
- (void)parserDidEndDictionary:(PCKJSONParser *)parser;
- (void)parserDidStartArray:(PCKJSONParser *)parser;
- (void)parserDidEndArray:(PCKJSONParser *)parser;
- (void)parser:(PCKJSONParser *)parser didFindKey:(NSString *)key;
- (void)parser:(PCKJSONParser *)parser didFindValue:(id)value;
@end

typedef void (^PCKJSONParserDelegateContainerBlock)();
typedef void (^PCKJSONParserDelegateKeyBlock)(NSString *);
typedef void (^PCKJSONParserDelegateValueBlock)(id);

@interface PCKJSONParserDelegate : NSObject <PCKJSONParserDelegate>

@property (nonatomic, copy) PCKJSONParserDelegateContainerBlock didStartDictionary, didEndDictionary;
@property (nonatomic, copy) PCKJSONParserDelegateContainerBlock didStartArray, didEndArray;
@property (nonatomic, copy) PCKJSONParserDelegateKeyBlock didFindKey;
@property (nonatomic, copy) PCKJSONParserDelegateValueBlock didFindValue;
@property (nonatomic, copy) PCKParserErrorBlock didEncounterError;

@end
