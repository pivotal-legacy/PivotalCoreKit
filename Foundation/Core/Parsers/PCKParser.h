#import <Foundation/Foundation.h>

@protocol PCKParserDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol PCKParser <NSObject>

- (void)setDelegate:(id<PCKParserDelegate>)delegate;
- (void)parseChunk:(NSData *)chunk;

@end

NS_ASSUME_NONNULL_END
