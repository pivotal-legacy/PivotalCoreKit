#import "PSHKFixtures.h"
#import <Cedar/SpecHelper.h>

@implementation SpecHelper (PivotalCoreKitSpecs)

- (void)beforeEach {
    [PSHKFixtures setDirectory:@FIXTURESDIR];
}

@end
