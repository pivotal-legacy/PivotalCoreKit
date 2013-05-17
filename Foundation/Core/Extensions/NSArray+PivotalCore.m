#import "NSArray+PivotalCore.h"

@implementation NSArray (PivotalCore)

- (NSArray *)collectWithKeyPath:(NSString *)keyPath {
    return [self collect:^id(id item) {
        return [item valueForKeyPath:keyPath];
    }];
}

- (NSArray *)collect:(id(^)(id))collector {
    return [self collect:collector boxNils:NO];
}

- (NSArray *)collect:(id(^)(id))collector boxNils:(BOOL)shouldBox {
    if (collector == nil) {
        return [NSArray arrayWithArray:self];
    }

    NSMutableArray *collected = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = collector(obj);
        if (result) {
            [collected addObject:result];
        } else if (shouldBox) {
            [collected addObject:[NSNull null]];
        }
    }];
    return [NSArray arrayWithArray:collected];
}

@end
