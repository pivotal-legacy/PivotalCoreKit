#import <Foundation/Foundation.h>

@interface NSInvocation (InvocationMatching)

- (BOOL)matchesTarget:(id)target selector:(SEL)selector arguments:(NSArray *)arguments;

@end
