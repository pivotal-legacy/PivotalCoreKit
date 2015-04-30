#import "UIApplication+Spec.h"

@implementation UIApplication (Spec)

static NSMutableArray *URLs = nil;

+ (void)load {
    URLs = [NSMutableArray array];
}

+ (void)afterEach {
    [self reset];
}

+ (void)reset {
    [URLs removeAllObjects];
}

+ (NSURL *)lastOpenedURL {
    return [URLs lastObject];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)openURL:(NSURL *)url {
    [URLs addObject:url];
}
#pragma clang diagnostic pop

@end
