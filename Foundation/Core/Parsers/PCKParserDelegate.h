#import <Foundation/Foundation.h>

@protocol PCKParser;

typedef void (^PCKParserErrorBlock)(NSError *);

@protocol PCKParserDelegate

- (void)parser:(id<PCKParser>)parser didEncounterError:(NSError *)error;

@end
