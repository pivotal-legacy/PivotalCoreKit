#import "PCKMessageCapturer.h"

typedef NS_ENUM(NSInteger, WKUserNotificationInterfaceType)  {
    WKUserNotificationInterfaceTypeDefault,
    WKUserNotificationInterfaceTypeCustom,
};

@class WKInterfaceTable;
@class WKAlertAction;

typedef NS_ENUM(NSInteger, WKMenuItemIcon)  {
    WKMenuItemIconAccept,       // checkmark
    WKMenuItemIconAdd,          // '+'
    WKMenuItemIconBlock,        // circle w/ slash
    WKMenuItemIconDecline,      // 'x'
    WKMenuItemIconInfo,         // 'i'
    WKMenuItemIconMaybe,        // '?'
    WKMenuItemIconMore,         // '...'
    WKMenuItemIconMute,         // speaker w/ slash
    WKMenuItemIconPause,        // pause button
    WKMenuItemIconPlay,         // play button
    WKMenuItemIconRepeat,       // looping arrows
    WKMenuItemIconResume,       // circular arrow
    WKMenuItemIconShare,        // share icon
    WKMenuItemIconShuffle,      // swapped arrows
    WKMenuItemIconSpeaker,      // speaker icon
    WKMenuItemIconTrash,        // trash icon
};

typedef NS_ENUM(NSInteger, WKTextInputMode)  {
    WKTextInputModePlain,
    WKTextInputModeAllowEmoji,
    WKTextInputModeAllowAnimatedEmoji,
};

typedef NS_ENUM(NSInteger, WKAlertControllerStyle) {
    WKAlertControllerStyleAlert,
    WKAlertControllerStyleSideBySideButtonsAlert,
    WKAlertControllerStyleActionSheet,
};


@interface WKInterfaceController : PCKMessageCapturer

- (void)awakeWithContext:(id)context;

- (void)willActivate;
- (void)didDeactivate;

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex;
- (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification;
- (void)handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)localNotification;
- (void)handleUserActivity:(NSDictionary *)userInfo;

- (void)setTitle:(NSString *)title;

- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)popController;
- (void)popToRootController;

+ (void)reloadRootControllersWithNames:(NSArray *)names contexts:(NSArray *)contexts;
- (void)becomeCurrentPage;

- (void)presentControllerWithName:(NSString *)name context:(id)context;
- (void)presentControllerWithNames:(NSArray *)names contexts:(NSArray *)contexts;
- (void)dismissController;

- (void)presentTextInputControllerWithSuggestions:(NSArray *)suggestions
                                 allowedInputMode:(WKTextInputMode)inputMode
                                       completion:(void(^)(NSArray *results))completion;
- (void)dismissTextInputController;

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier;
- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier;
- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex;
- (NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex;

- (void)addMenuItemWithImage:(UIImage *)image title:(NSString *)title action:(SEL)action;
- (void)addMenuItemWithImageNamed:(NSString *)imageName title:(NSString *)title action:(SEL)action;
- (void)addMenuItemWithItemIcon:(WKMenuItemIcon)itemIcon title:(NSString *)title action:(SEL)action;
- (void)clearAllMenuItems;

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WKAlertControllerStyle)preferredStyle actions:(NSArray <WKAlertAction *>*)actions;

- (void)updateUserActivity:(NSString *)type userInfo:(NSDictionary *)userInfo;
- (void)updateUserActivity:(NSString *)type userInfo:(NSDictionary *)userInfo webpageURL:(NSURL *)webpageURL;

+ (BOOL)openParentApplication:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo, NSError *error)) reply;

@end

@interface WKUserNotificationInterfaceController : WKInterfaceController

//- (instancetype)init;
- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification
                      withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler;
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
                     withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler;

@end
