#import <Foundation/Foundation.h>

@protocol PCKParser;

NS_ASSUME_NONNULL_BEGIN

typedef void (^PCKParserErrorBlock)(NSError * __nonnull error);

@protocol PCKParserDelegate

- (void)parser:(id<PCKParser>)parser didEncounterError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
