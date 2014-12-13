#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"


@interface WKInterfaceController ()

@property (nonatomic) WKInterfaceController *childController;
@property (nonatomic) WKInterfaceController *presentedController;
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
    self.childController = [self.loader interfaceControllerWithStoryboardName:@"Interface"
                                                                   identifier:name
                                                                      context:context];
}

- (void)presentControllerWithName:(NSString *)name context:(id)context
{
    self.presentedController = [self.loader interfaceControllerWithStoryboardName:@"Interface"
                                                                       identifier:name
                                                                          context:context];
}

@end

