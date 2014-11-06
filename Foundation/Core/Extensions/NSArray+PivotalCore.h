#import <Foundation/Foundation.h>

@interface NSArray (PivotalCore)

- (NSArray *)collect:(id(^)(id))collector;
- (NSArray *)collect:(id(^)(id))collector boxNils:(BOOL)shouldBox;
- (NSArray *)collectWithKeyPath:(NSString *)keyPath;

- (id)reduce:(id(^)(id accumulator, id input))f initialValue:(id)initialValue;
- (id)reduce:(id(^)(id accumulator, id input))f;

- (instancetype)map:(id(^)(id))f;

@end
