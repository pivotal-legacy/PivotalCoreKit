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
    if (!collector) {
        return [NSArray arrayWithArray:self];
    }

    return [self reduce:^id(id accumulator, id input) {
        id v = collector(input);
        if (v) {
            [accumulator addObject:v];
        } else if (shouldBox) {
            [accumulator addObject:[NSNull null]];
        }
        return accumulator;
    } initialValue:[NSMutableArray arrayWithCapacity:self.count]];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id)reduce:(id(^)(id accumulator, id input))f initialValue:(id)initialValue {
    NSParameterAssert(f);
    id accumulator = initialValue;
    for (id o in self) {
        accumulator = f(accumulator, o);
    }
    return accumulator;
}

- (id)reduce:(id(^)(id accumulator, id input))f {
    NSParameterAssert(f);
    return [[self subarrayWithRange:NSMakeRange(1, self.count - 1)] reduce:f initialValue:[self objectAtIndex:0]];
}

- (id)map:(id(^)(id))f {
    NSParameterAssert(f);
    return [self reduce:^id(id accumulator, id input) {
        [accumulator addObject:f(input)];
        return accumulator;
    } initialValue:[NSMutableArray arrayWithCapacity:self.count]];
}

- (id)filter:(BOOL(^)(id))f {
    NSParameterAssert(f);
    return [self reduce:^id(id accumulator, id input) {
        if (f(input)) {
            [accumulator addObject:input];
        }
        return accumulator;
    } initialValue:[NSMutableArray array]];
}
#pragma clang diagnostic pop

@end
