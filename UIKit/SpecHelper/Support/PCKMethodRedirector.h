#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKMethodRedirector : NSObject

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;
+ (void)redirectPCKReplaceSelectorsForClass:(Class)klass;
+ (void)redirectSelectorsWithPrefix:(NSString *)prefix forClass:(Class)klass andRenamePrefixTo:(NSString *)newPrefix;

@end

NS_ASSUME_NONNULL_END
