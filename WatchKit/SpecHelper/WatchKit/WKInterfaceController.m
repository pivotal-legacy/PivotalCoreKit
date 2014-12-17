#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"

@interface MessageCapturer ()

- (void)awakeWithContext:(id)context NS_REQUIRES_SUPER;
- (void)willActivate NS_REQUIRES_SUPER;
- (void)didDeactivate NS_REQUIRES_SUPER;
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex NS_REQUIRES_SUPER;
- (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification NS_REQUIRES_SUPER;
- (void)handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)localNotification NS_REQUIRES_SUPER;
- (NSString *)actionForUserActivity:(NSDictionary *)userActivity context:(id *)context NS_REQUIRES_SUPER;

- (void)pushControllerWithName:(NSString *)name context:(id)context NS_REQUIRES_SUPER;
- (void)popController NS_REQUIRES_SUPER;;
- (void)popToRootController NS_REQUIRES_SUPER;;

- (void)setTitle:(NSString *)title NS_REQUIRES_SUPER;

- (void)becomeCurrentPage NS_REQUIRES_SUPER;

- (void)presentControllerWithName:(NSString *)name context:(id)context NS_REQUIRES_SUPER;
- (void)presentControllerWithNames:(NSArray *)names contexts:(NSArray *)contexts NS_REQUIRES_SUPER;

- (void)dismissController NS_REQUIRES_SUPER;

@end


@implementation WKInterfaceController

- (void)awakeWithContext:(id)context 
{
    [super awakeWithContext:context];
}

- (void)willActivate
{
    [super willActivate];
}

- (void)didDeactivate
{
    [super didDeactivate];
}

- (void)pushControllerWithName:(NSString *)name context:(id)context
{
    [super pushControllerWithName:name context:context];
}

- (void)presentControllerWithName:(NSString *)name context:(id)context
{
    [super presentControllerWithName:name context:context];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [super table:table didSelectRowAtIndex:rowIndex];
}

- (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification
{
    [super handleActionWithIdentifier:identifier forRemoteNotification:remoteNotification];
}

- (void)handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)localNotification
{
    [super handleActionWithIdentifier:identifier forLocalNotification:localNotification];
}

- (NSString *)actionForUserActivity:(NSDictionary *)userActivity context:(id *)context
{
    [super actionForUserActivity:userActivity context:context];
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}

- (void)popController {
    [super popController];
}

- (void)popToRootController
{
    [super popToRootController];
}

- (void)becomeCurrentPage
{
    [super becomeCurrentPage];
}

- (void)presentControllerWithNames:(NSArray *)names contexts:(NSArray *)contexts
{
    [super presentControllerWithNames:names contexts:contexts];
}

- (void)dismissController
{
    [super dismissController];
}

@end

