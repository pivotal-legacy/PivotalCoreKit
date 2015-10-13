

#import "WKInterfaceObject.h"

typedef NS_ENUM(NSInteger, WKAlertActionStyle) {
    WKAlertActionStyleDefault = 0,
    WKAlertActionStyleCancel,
    WKAlertActionStyleDestructive
};

typedef void (^WKAlertActionHandler)(void)

@interface WKAlertAction : WKInterfaceObject

+ (instancetype)actionWithTitle:(NSString *)title style:(WKAlertActionStyle)style handler:(WKAlertActionHandler)handler;


@end
