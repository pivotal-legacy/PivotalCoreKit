#import "MethodImplementation.h"

@implementation MethodImplementation

@synthesize implementation;

+ (MethodImplementation *)withImplementation:(IMP)imp {
    return [[[self alloc] initWithImplementation:imp] autorelease];
}

- (MethodImplementation *)initWithImplementation:(IMP)imp {
    self = [super init];
    if (self) {
        self.implementation = imp;
    }
    return self;
}

@end