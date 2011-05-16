#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MockMethod : NSObject {
    IMP implementation;
    id returnValue;
    id (^substituteBlock)();
    Method originalMethod;
}

@property (nonatomic, assign, readonly) IMP implementation;
@property (nonatomic, retain) id returnValue;
@property (nonatomic, assign) Method originalMethod;
@property (nonatomic, copy) id (^substituteBlock)();

+ (MockMethod *)withImplementation:(IMP)imp;
- (MockMethod *)initWithImplementation:(IMP)imp;

@end

