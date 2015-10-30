#import <Foundation/Foundation.h>
#import "PCKReducable.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (PivotalCore)

- (NSArray *)collect:(__nullable id(^)(id))collector;
- (NSArray *)collect:(__nullable id(^)(id))collector boxNils:(BOOL)shouldBox;
- (NSArray *)collectWithKeyPath:(NSString *)keyPath;

@end

@interface NSArray () <PCKReducable>
@end

NS_ASSUME_NONNULL_END
