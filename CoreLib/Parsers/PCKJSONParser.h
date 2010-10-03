#import <Foundation/Foundation.h>
#import "PCKParser.h"

#if TARGET_OS_IPHONE
#import <YAJLIOS/YAJLIOS.h>
#else
#import <YAJL/YAJL.h>
#endif

@protocol PCKJSONParserDelegate;

@interface PCKJSONParser : NSObject<PCKParser, YAJLParserDelegate>

- (id)initWithDelegate:(id<PCKJSONParserDelegate>)delegate;


@end




