#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (InvocationMatching)

- (BOOL)matchesTarget:(id)target selector:(SEL)selector arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
