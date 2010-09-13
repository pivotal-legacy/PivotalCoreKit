#import <Foundation/Foundation.h>

@protocol PCKXMLParserDelegate
- (void)didStartElement:(const char *)elementName;
- (void)didEndElement:(const char *)elementName;
- (void)didFindCharacters:(const char *)characters;
@end

typedef void (^PCKXMLParserDelegateBlock)(const char *);

@interface PCKXMLParserDelegate : NSObject <PCKXMLParserDelegate>

@property (nonatomic, copy) PCKXMLParserDelegateBlock didStartElement, didEndElement, didFindCharacters;

@end
