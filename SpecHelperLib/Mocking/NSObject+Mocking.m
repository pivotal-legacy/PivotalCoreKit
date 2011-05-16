#import "NSObject+Mocking.h"
#import <objc/runtime.h>
#import "MethodImplementation.h"

static NSMutableDictionary *originalImplementations = nil;
static NSMutableDictionary *returnValues = nil;

@interface NSObject() 
+ (id)aMethod;
@end

@implementation NSObject (PrivateInterface)
+ (id)aMethod:(id)firstArg, ... {
    NSString *key = [NSString stringWithFormat:@"%@,%@", [self class], NSStringFromSelector(_cmd)];    
    return [returnValues objectForKey:key];
}
@end

@implementation NSObject (Mocking)

+ (void)stub:(SEL)selector andReturn:(id)returnValue {
    Method originalMethod;
    IMP originalImplementation;
        
    if (!originalImplementations) {
        originalImplementations = [[NSMutableDictionary alloc] init];
    } 
    
    if (!returnValues) {
        returnValues = [[NSMutableDictionary alloc] init];
    }
    
    Method replacementMethod = class_getClassMethod([NSObject class], @selector(aMethod:));
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    originalMethod = class_getClassMethod([self class], selector);
    originalImplementation = method_getImplementation(originalMethod);
    
    NSString *key = [NSString stringWithFormat:@"%@,%@", [self class], NSStringFromSelector(selector)];
    
    [originalImplementations setObject:[MethodImplementation withImplementation:originalImplementation]
                                forKey:key];

    if (returnValue) {
        [returnValues setObject:returnValue forKey:key];        
    }

    method_setImplementation(originalMethod, replacementImplementation);
}

+ (void)resetAllStubbedMethods {
    for(NSString * key in originalImplementations) {
        NSArray * keyComponents = [key componentsSeparatedByString:@","];
        Class class = NSClassFromString([keyComponents objectAtIndex:0]);
        SEL selector = NSSelectorFromString([keyComponents objectAtIndex:1]);
        Method method = class_getClassMethod(class, selector);
        MethodImplementation * implementation = [originalImplementations objectForKey:key];
        method_setImplementation(method, implementation.implementation);
    }
    
    [returnValues release];
    returnValues = nil;
    [originalImplementations release];
    originalImplementations = nil;
}

@end

