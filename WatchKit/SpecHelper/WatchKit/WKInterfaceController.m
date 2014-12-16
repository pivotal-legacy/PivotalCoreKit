#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"

@interface MessageCapturer ()

- (void)pushControllerWithName:(NSString *)name context:(id)context NS_REQUIRES_SUPER;
- (void)presentControllerWithName:(NSString *)name context:(id)context NS_REQUIRES_SUPER;

@end


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

- (void)pushControllerWithName:(NSString *)name context:(id)context
{
    [super pushControllerWithName:name context:context];
}

- (void)presentControllerWithName:(NSString *)name context:(id)context
{
    [super presentControllerWithName:name context:context];
}

@end

