#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"


@interface WKInterfaceController ()

@property (nonatomic) InterfaceControllerLoader *loader;

@end


@implementation WKInterfaceController

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

@end

