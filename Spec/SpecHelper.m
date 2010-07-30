#import "Fixtures.h"
#import <Cedar/SpecHelper.h>

@implementation SpecHelper (PivotalCoreKitSpecs)

- (void)beforeEach {
    [Fixtures setDirectory:@FIXTURESDIR];
}

@end
