#import "FakeInterfaceController.h"


@interface FakeInterfaceController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic) id context;

@end


@implementation FakeInterfaceController

- (instancetype)initWithName:(NSString *)name
                     context:(id)context
{
    self = [super init];
    if (self) {
        self.name = name;
        self.context = context;
    }
    return self;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
