#import <Foundation/Foundation.h>

@protocol PCKReducable <NSObject>

- (id)reduce:(id(^)(id accumulator, id input))f initialValue:(id)initialValue;
- (id)reduce:(id(^)(id accumulator, id input))f;

- (id)map:(id(^)(id))f;

- (id)filter:(BOOL(^)(id))f;

@end
