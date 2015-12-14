#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PCKReducable <NSObject>

- (nullable id)reduce:(__nullable id(^)(__nullable id accumulator, id input))f initialValue:(nullable id)initialValue;
- (nullable id)reduce:(__nullable id(^)(__nullable id accumulator, id input))f;

- (id)map:(id(^)(id))f;

- (id)filter:(BOOL(^)(id))f;

@end

NS_ASSUME_NONNULL_END
