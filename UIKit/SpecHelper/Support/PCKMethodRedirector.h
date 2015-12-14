#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKMethodRedirector : NSObject

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;

@end

NS_ASSUME_NONNULL_END
