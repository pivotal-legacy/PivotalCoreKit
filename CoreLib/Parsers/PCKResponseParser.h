#import <Foundation/Foundation.h>

@protocol PCKParser;

@interface PCKResponseParser : NSObject<NSURLConnectionDelegate>

- (id)initWithParser:(id<PCKParser>)parser andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
