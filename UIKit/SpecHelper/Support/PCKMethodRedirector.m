#import "PCKMethodRedirector.h"
#import <objc/runtime.h>


bool startsWith(const char *pre, const char *str) {
    size_t lenpre = strlen(pre),
           lenstr = strlen(str);
    return lenstr < lenpre ? false : memcmp(pre, str, lenpre) == 0;
}

@implementation PCKMethodRedirector

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

+ (void)redirectPCKReplaceSelectorsForClass:(Class)klass {
    [self redirectSelectorsWithPrefix:@"pck_replace_" forClass:klass andRenamePrefixTo:@"_pck_preserved_"];
}

+ (void)redirectSelectorsWithPrefix:(NSString *)prefix forClass:(Class)klass andRenamePrefixTo:(NSString *)newPrefix {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(klass, &methodCount);

    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];

        SEL sel = method_getName(method);
        const char *cName = sel_getName(sel);
        if (startsWith([prefix cStringUsingEncoding:NSUTF8StringEncoding], cName)) {
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            NSString *withoutPrefix = [name substringFromIndex:prefix.length];
            NSString *replacedPrefix = [newPrefix stringByAppendingString:withoutPrefix];
            [self redirectSelector:NSSelectorFromString(withoutPrefix)
                          forClass:klass
                                to:sel
                     andRenameItTo:NSSelectorFromString(replacedPrefix)];
        }
    }

    free(methods);
}

@end
