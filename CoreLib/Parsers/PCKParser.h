#import <Foundation/Foundation.h>

@protocol PCKParser <NSObject>

- (void)parseChunk:(NSData *)chunk;

@end
