#import <Foundation/Foundation.h>

@protocol PCKParserDelegate;

@protocol PCKParser <NSObject>

- (void)setDelegate:(id<PCKParserDelegate>)delegate;
- (void)parseChunk:(NSData *)chunk;

@end
