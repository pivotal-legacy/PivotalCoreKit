#import "NSUUID+Spec.h"
#import "NSObject+MethodRedirection.h"
#import <objc/runtime.h>

@interface NSUUID (Spec_Private)
+ (NSUUID *)UUIDWithoutLogging;
+ (NSUUID *)UUIDWithLogging;
@end

static NSMutableArray *uuids;
@implementation NSUUID (Spec)
+ (NSArray *)generatedUUIDs {
    return uuids;
}

+ (void)beforeEach {
    [self reset];
}

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
    [NSUUID redirectClassSelector:@selector(UUID)
                              to:@selector(UUIDWithLogging)
                    andRenameItTo:@selector(UUIDWithoutLogging)];

    uuids = [[NSMutableArray alloc] init];
}

+ (NSUUID *)UUIDWithLogging {
    NSUUID *uuid = [self UUIDWithoutLogging];
    [uuids addObject:uuid];

    return uuid;
}

+ (void)reset {
    uuids = [[NSMutableArray alloc] init];
}

@end
