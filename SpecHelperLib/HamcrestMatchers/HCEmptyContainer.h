#if TARGET_OS_IPHONE
#import "HCBaseMatcher.h"
#else
#import <OCHamcrest/HCBaseMatcher.h>
#endif

@interface HCEmptyContainer : HCBaseMatcher

+ (id)emptyContainer;

@end

id<HCMatcher> HC_emptyContainer();

#ifdef HC_SHORTHAND
#define emptyContainer HC_emptyContainer
#endif
