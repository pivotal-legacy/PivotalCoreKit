#import <Foundation/Foundation.h>
#import "PCKReducable.h"

@interface NSArray (PivotalCore)

- (NSArray *)collect:(id(^)(id))collector;
- (NSArray *)collect:(id(^)(id))collector boxNils:(BOOL)shouldBox;
- (NSArray *)collectWithKeyPath:(NSString *)keyPath;

@end

@interface NSArray () <PCKReducable>
@end
