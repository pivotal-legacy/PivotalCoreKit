#import <Foundation/Foundation.h>

#if __has_include("NSURLConnectionDelegate.h")
# import "NSURLConnectionDelegate.h"
#endif

@protocol PCKParser, PCKParserDelegate;

@interface PCKResponseParser : NSObject<NSURLConnectionDataDelegate>

- (id)initWithParser:(id<PCKParser>)parser successParserDelegate:(id<PCKParserDelegate>)successParserDelegate errorParserDelegate:(id<PCKParserDelegate>)errorParserDelegate connectionDelegate:(id<NSURLConnectionDelegate>)connectionDelegate;

@end
