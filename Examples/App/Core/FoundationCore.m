#import <PivotalCoreKit/Foundation+PivotalCore.h>

#import "FoundationCore.h"

@implementation FoundationCore

- (NSString *)stringRetrievedViaTypesafeExtraction {
    NSDictionary *strings = @{ @"one": @"A", @"two": @"B" };
    return [strings stringObjectForKey:@"one"];
}

@end
