#import <Foundation/Foundation.h>

@interface MethodImplementation : NSObject {
    IMP implementation;
}

@property (nonatomic, assign) IMP implementation;

+ (MethodImplementation *)withImplementation:(IMP)imp;
- (MethodImplementation *)initWithImplementation:(IMP)imp;

@end

