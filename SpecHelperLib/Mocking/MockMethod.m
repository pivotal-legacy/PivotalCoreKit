#import "MockMethod.h"

@implementation MockMethod

@synthesize implementation, returnValue;

- (void)dealloc {
    self.returnValue = nil;
    [super dealloc];
}

+ (MockMethod *)withImplementation:(IMP)imp {
    return [[[self alloc] initWithImplementation:imp] autorelease];
}

- (MockMethod *)initWithImplementation:(IMP)imp {
    self = [super init];
    if (self) {
        implementation = imp;
    }
    return self;
}

@end