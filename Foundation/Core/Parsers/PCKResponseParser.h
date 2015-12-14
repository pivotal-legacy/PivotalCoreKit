#import <Foundation/Foundation.h>

#if __has_include("NSURLConnectionDelegate.h")
# import "NSURLConnectionDelegate.h"
#endif

@protocol PCKParser, PCKParserDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface PCKResponseParser : NSObject<NSURLConnectionDataDelegate>

- (id)initWithParser:(id<PCKParser>)parser successParserDelegate:(id<PCKParserDelegate>)successParserDelegate errorParserDelegate:(id<PCKParserDelegate>)errorParserDelegate connectionDelegate:(nullable id<NSURLConnectionDelegate>)connectionDelegate;

@end

NS_ASSUME_NONNULL_END
