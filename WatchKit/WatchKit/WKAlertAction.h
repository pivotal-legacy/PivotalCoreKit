#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WKAlertActionStyle) {
    WKAlertActionStyleDefault = 0,
    WKAlertActionStyleCancel,
    WKAlertActionStyleDestructive
};

typedef void (^WKAlertActionHandler)(void);

@interface WKAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title style:(WKAlertActionStyle)style handler:(WKAlertActionHandler)handler;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
