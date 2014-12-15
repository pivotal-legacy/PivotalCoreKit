#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"


@interface WKInterfaceController ()

@property (nonatomic) NSMutableArray *sent_messages;
@property (nonatomic) InterfaceControllerLoader *loader;

@end


@implementation WKInterfaceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sent_messages = [NSMutableArray array];
    }
    return self;
}

- (void)awakeWithContext:(id)context 
{
    self.loader = [[InterfaceControllerLoader alloc] init];
}

- (void)willActivate
{
    
}

- (void)didDeactivate
{
    
}

#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [self.sent_messages addObject:anInvocation];
}

@end

