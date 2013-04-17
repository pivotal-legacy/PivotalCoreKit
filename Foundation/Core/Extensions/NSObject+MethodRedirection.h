#import <Foundation/Foundation.h>


@interface NSObject (MethodRedirection)

+ (void)redirectSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;
+ (void)redirectClassSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;

@end
