#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@protocol PCKParser, PCKParserDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface PCKResponseParser : NSObject<NSURLConnectionDataDelegate>

- (id)initWithParser:(id<PCKParser>)parser successParserDelegate:(id<PCKParserDelegate>)successParserDelegate errorParserDelegate:(id<PCKParserDelegate>)errorParserDelegate connectionDelegate:(nullable id<NSURLConnectionDelegate>)connectionDelegate;

@end

NS_ASSUME_NONNULL_END
