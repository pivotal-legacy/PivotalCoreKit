#import "WKInterfaceController.h"
#import "PCKInterfaceControllerLoader.h"


@interface PCKMessageCapturer ()

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

- (void)presentTextInputControllerWithSuggestions:(NSArray *)suggestions
                                 allowedInputMode:(WKTextInputMode)inputMode
                                       completion:(void(^)(NSArray *results))completion NS_REQUIRES_SUPER;
- (void)dismissTextInputController NS_REQUIRES_SUPER;

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier NS_REQUIRES_SUPER;
- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier NS_REQUIRES_SUPER;
- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex NS_REQUIRES_SUPER;
- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex NS_REQUIRES_SUPER;

- (void)addMenuItemWithImage:(UIImage *)image title:(NSString *)title action:(SEL)action NS_REQUIRES_SUPER;
- (void)addMenuItemWithImageNamed:(NSString *)imageName title:(NSString *)title action:(SEL)action NS_REQUIRES_SUPER;
- (void)addMenuItemWithItemIcon:(WKMenuItemIcon)itemIcon title:(NSString *)title action:(SEL)action NS_REQUIRES_SUPER;
- (void)clearAllMenuItems NS_REQUIRES_SUPER;

- (void)updateUserActivity:(NSString *)type userInfo:(NSDictionary *)userInfo NS_REQUIRES_SUPER;

- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification
                      withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler NS_REQUIRES_SUPER;
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
                     withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler NS_REQUIRES_SUPER;

+ (BOOL)openParentApplication:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo, NSError *error)) reply NS_REQUIRES_SUPER;
+ (void)reloadRootControllersWithNames:(NSArray *)names contexts:(NSArray *)contexts NS_REQUIRES_SUPER;

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

- (void)presentTextInputControllerWithSuggestions:(NSArray *)suggestions
                                 allowedInputMode:(WKTextInputMode)inputMode
                                       completion:(void(^)(NSArray *results))completion
{
    [super presentTextInputControllerWithSuggestions:suggestions allowedInputMode:inputMode completion:completion];
}

- (void)dismissTextInputController
{
    [super dismissTextInputController];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
{
    [super contextForSegueWithIdentifier:segueIdentifier];
    return nil;
}

- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier
{
    [super contextsForSegueWithIdentifier:segueIdentifier];
    return nil;
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex
{
    [super contextForSegueWithIdentifier:segueIdentifier inTable:table rowIndex:rowIndex];
    return nil;
}

- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex
{
    [super contextsForSegueWithIdentifier:segueIdentifier inTable:table rowIndex:rowIndex];
    return nil;
}

- (void)addMenuItemWithImage:(UIImage *)image title:(NSString *)title action:(SEL)action
{
    [super addMenuItemWithImage:image title:title action:action];
}

- (void)addMenuItemWithImageNamed:(NSString *)imageName title:(NSString *)title action:(SEL)action
{
    [super addMenuItemWithImageNamed:imageName title:title action:action];
}

- (void)addMenuItemWithItemIcon:(WKMenuItemIcon)itemIcon title:(NSString *)title action:(SEL)action
{
    [super addMenuItemWithItemIcon:itemIcon title:title action:action];
}

- (void)clearAllMenuItems
{
    [super clearAllMenuItems];
}

- (void)updateUserActivity:(NSString *)type userInfo:(NSDictionary *)userInfo
{
    [super updateUserActivity:type userInfo:userInfo];
}

+ (BOOL)openParentApplication:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo, NSError *error)) reply
{
    return [super openParentApplication:userInfo reply:reply];
}

+ (void)reloadRootControllersWithNames:(NSArray *)names contexts:(NSArray *)contexts
{
    [super reloadRootControllersWithNames:names contexts:contexts];
}

@end


@interface WKUserNotificationInterfaceController ()
@property (nonatomic, copy) void (^lastCompletionBlock)(WKUserNotificationInterfaceType);
@end


@implementation WKUserNotificationInterfaceController

- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification
                      withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler
{
    self.lastCompletionBlock = completionHandler;
    [super didReceiveRemoteNotification:remoteNotification withCompletion:completionHandler];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
                      withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler
{
    self.lastCompletionBlock = completionHandler;
    [super didReceiveLocalNotification:localNotification withCompletion:completionHandler];
}

@end