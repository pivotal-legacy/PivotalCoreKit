#import <Foundation/Foundation.h>
#import "PSHKFixtures.h"

@interface FixturesHelper : NSObject; @end
@implementation FixturesHelper

+ (void)beforeEach {
    [PSHKFixtures setDirectory:@FIXTURESDIR];
}

@end
