#import <Foundation/Foundation.h>
#import "PSHKFixtures.h"
#import "CDRHooks.h"

@interface FixturesHelper : NSObject<CDRHooks>; @end
@implementation FixturesHelper

+ (void)beforeEach {
    [PSHKFixtures setDirectory:@FIXTURESDIR];
}

@end
