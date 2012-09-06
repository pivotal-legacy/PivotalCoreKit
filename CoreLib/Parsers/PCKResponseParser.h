#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@protocol PCKParser, PCKParserDelegate;

@interface PCKResponseParser : NSObject<NSURLConnectionDataDelegate>

- (id)initWithParser:(id<PCKParser>)parser successParserDelegate:(id<PCKParserDelegate>)successParserDelegate errorParserDelegate:(id<PCKParserDelegate>)errorParserDelegate connectionDelegate:(id<NSURLConnectionDelegate>)connectionDelegate;

@end
