#import "NSBundle+BuildHelper.h"

@implementation NSBundle (BuildHelper)

+ (instancetype)buildHelperBundle {
    NSURL *embeddedBundleURL = [[NSBundle mainBundle] URLForResource:@"SpecBuildHelper" withExtension:@"app"];
    return [self bundleWithURL:embeddedBundleURL];
}

@end
