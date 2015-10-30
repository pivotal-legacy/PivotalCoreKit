#import "PCKMessageCapturer.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)awakeWithContext:(nullable id)context;

- (void)willActivate;
- (void)didDeactivate;

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex;
- (void)handleActionWithIdentifier:(nullable NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification;
- (void)handleActionWithIdentifier:(nullable NSString *)identifier
              forLocalNotification:(UILocalNotification *)localNotification;
- (void)handleUserActivity:(nullable NSDictionary *)userInfo;

- (void)setTitle:(NSString *)title;

- (void)pushControllerWithName:(NSString *)name context:(nullable id)context;
- (void)popController;
- (void)popToRootController;

+ (void)reloadRootControllersWithNames:(NSArray<NSString *> *)names contexts:(nullable NSArray *)contexts;
- (void)becomeCurrentPage;

- (void)presentControllerWithName:(NSString *)name context:(nullable id)context;
- (void)presentControllerWithNames:(NSArray<NSString *> *)names contexts:(nullable NSArray *)contexts;
- (void)dismissController;

- (void)presentTextInputControllerWithSuggestions:(nullable NSArray<NSString *> *)suggestions
                                 allowedInputMode:(WKTextInputMode)inputMode
                                       completion:(void(^)(NSArray * __nullable results))completion;
- (void)dismissTextInputController;

- (nullable id)contextForSegueWithIdentifier:(NSString *)segueIdentifier;
- (nullable NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier;
- (nullable id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex;
- (nullable NSArray *)contextsForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex;

- (void)addMenuItemWithImage:(UIImage *)image title:(NSString *)title action:(SEL)action;
- (void)addMenuItemWithImageNamed:(NSString *)imageName title:(NSString *)title action:(SEL)action;
- (void)addMenuItemWithItemIcon:(WKMenuItemIcon)itemIcon title:(NSString *)title action:(SEL)action;
- (void)clearAllMenuItems;

- (void)presentAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(WKAlertControllerStyle)preferredStyle actions:(NSArray <WKAlertAction *>*)actions;

- (void)updateUserActivity:(NSString *)type userInfo:(nullable NSDictionary *)userInfo;
- (void)updateUserActivity:(NSString *)type userInfo:(nullable NSDictionary *)userInfo webpageURL:(nullable NSURL *)webpageURL;

+ (BOOL)openParentApplication:(NSDictionary *)userInfo reply:(nullable void(^)(NSDictionary *replyInfo, NSError * __nullable error)) reply;

@end

@interface WKUserNotificationInterfaceController : WKInterfaceController

//- (instancetype)init;
- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification
                      withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler;
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
                     withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler;

@end

NS_ASSUME_NONNULL_END
