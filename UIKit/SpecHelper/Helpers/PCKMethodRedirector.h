#import <Foundation/Foundation.h>

@interface PCKMethodRedirector : NSObject

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;

@end
