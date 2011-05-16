#import <Foundation/Foundation.h>

@interface MockMethod : NSObject {
    IMP implementation;
    id returnValue;
    id (^substituteBlock)();
}

@property (nonatomic, assign, readonly) IMP implementation;
@property (nonatomic, retain) id returnValue;
@property (nonatomic, copy) id (^substituteBlock)();

+ (MockMethod *)withImplementation:(IMP)imp;
- (MockMethod *)initWithImplementation:(IMP)imp;

@end

