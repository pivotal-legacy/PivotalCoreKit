#import "NSObject+Mocking.h"
#import <objc/runtime.h>
#import "MockMethod.h"

static NSMutableDictionary *mockMethods = nil;

@interface NSObject()
+ (id)aMethod;
@end

@implementation NSObject (PrivateInterface)

+ (id)aMethod:(id)firstArg, ... {
    NSString *key = [NSString stringWithFormat:@"%@,%@", [self class], NSStringFromSelector(_cmd)];
    MockMethod *mockMethod = [mockMethods objectForKey:key];

    id returnValue;
    if (mockMethod.substituteBlock) {

        NSUInteger numberOfArguments = method_getNumberOfArguments(mockMethod.originalMethod);
        NSMethodSignature * signature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(mockMethod.originalMethod)];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];

        if (numberOfArguments > 2) {
            [invocation setArgument:&firstArg atIndex:2];

            id arg;
            va_list args;
            va_start(args, firstArg);
            for (int i=3; i<numberOfArguments; i++) {
                arg=va_arg(args, id);
                [invocation setArgument:&arg atIndex:i];
            }
            va_end(args);
        }

        returnValue = mockMethod.substituteBlock(invocation);

    } else {
        returnValue = mockMethod.returnValue;
    }

    return returnValue;
}

@end

@implementation NSObject (Mocking)

+ (void)stub:(SEL)selector andReturn:(id)returnValue {
    Method originalMethod;
    IMP originalImplementation;

    if (!mockMethods) {
        mockMethods = [[NSMutableDictionary alloc] init];
    }

    Method replacementMethod = class_getClassMethod([NSObject class], @selector(aMethod:));
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    originalMethod = class_getClassMethod([self class], selector);
    originalImplementation = method_getImplementation(originalMethod);

    NSString *key = [NSString stringWithFormat:@"%@,%@", [self class], NSStringFromSelector(selector)];

    MockMethod * mockMethod = [MockMethod withImplementation:originalImplementation];
    mockMethod.returnValue = returnValue;
    [mockMethods setObject:mockMethod forKey:key];

    method_setImplementation(originalMethod, replacementImplementation);
}

+ (void)stub:(SEL)selector andDo:(id (^)(NSInvocation * invocation))substituteBlock {
    Method originalMethod;
    IMP originalImplementation;

    if (!mockMethods) {
        mockMethods = [[NSMutableDictionary alloc] init];
    }

    Method replacementMethod = class_getClassMethod([NSObject class], @selector(aMethod:));
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    originalMethod = class_getClassMethod([self class], selector);
    originalImplementation = method_getImplementation(originalMethod);

    NSString *key = [NSString stringWithFormat:@"%@,%@", [self class], NSStringFromSelector(selector)];

    MockMethod * mockMethod = [MockMethod withImplementation:originalImplementation];
    mockMethod.substituteBlock = substituteBlock;
    mockMethod.originalMethod = originalMethod;
    [mockMethods setObject:mockMethod forKey:key];

    method_setImplementation(originalMethod, replacementImplementation);
}

+ (void)resetAllStubbedMethods {
    for(NSString * key in mockMethods) {
        NSArray * keyComponents = [key componentsSeparatedByString:@","];
        Class class = NSClassFromString([keyComponents objectAtIndex:0]);
        SEL selector = NSSelectorFromString([keyComponents objectAtIndex:1]);
        Method method = class_getClassMethod(class, selector);
        MockMethod * implementation = [mockMethods objectForKey:key];
        method_setImplementation(method, implementation.implementation);
    }

    [mockMethods release];
    mockMethods = nil;
}

@end

