#import <Foundation/Foundation.h>
#import "PCKHTTPConnectionDelegate.h"

@protocol PCKParser;

@interface PCKResponseParser : NSObject<PCKHTTPConnectionDelegate>

- (id)initWithParser:(id<PCKParser>)parser andDelegate:(id<PCKHTTPConnectionDelegate>)delegate;

@end
