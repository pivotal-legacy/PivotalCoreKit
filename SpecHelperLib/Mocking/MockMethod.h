#import <Foundation/Foundation.h>

@interface MockMethod : NSObject {
    IMP implementation;
    id returnValue;
}

@property (nonatomic, assign, readonly) IMP implementation;
@property (nonatomic, retain) id returnValue;

+ (MockMethod *)withImplementation:(IMP)imp;
- (MockMethod *)initWithImplementation:(IMP)imp;

@end

