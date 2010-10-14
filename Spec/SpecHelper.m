#import "PSHKFixtures.h"
#import <Cedar/SpecHelper.h>

@implementation SpecHelper (PivotalCoreKitSpecs)

- (void)beforeEach {
    [NSURLConnection resetAll];
    [PSHKFixtures setDirectory:@FIXTURESDIR];
}

@end
