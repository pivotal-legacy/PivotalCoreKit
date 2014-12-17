#import "MessageCapturer.h"


@class WKInterfaceTable;


@interface WKInterfaceController : MessageCapturer

- (void)awakeWithContext:(id)context;

- (void)willActivate;
- (void)didDeactivate;

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex;
- (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification;
- (void)handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)localNotification;
- (NSString *)actionForUserActivity:(NSDictionary *)userActivity
                            context:(id *)context;

- (void)setTitle:(NSString *)title;

- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)popController;
- (void)popToRootController;

// TODO: + (void)reloadRootControllersWithNames:(NSArray *)names contexts:(NSArray *)contexts;
- (void)becomeCurrentPage;

- (void)presentControllerWithName:(NSString *)name context:(id)context;
- (void)presentControllerWithNames:(NSArray *)names contexts:(NSArray *)contexts;
- (void)dismissController;

@end
