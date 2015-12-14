#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;
@class WKInterfaceController;

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceButton (Spec)

- (nullable NSString *)title;
- (nullable UIColor *)color;
- (BOOL)enabled;
- (nullable NSString *)action;
- (nullable PCKFakeSegue *)segue;
- (nullable WKInterfaceGroup *)content;

@end

@interface WKInterfaceButton (Spec2)

@property (nonatomic, weak, nullable) WKInterfaceController *controller;

- (void)triggerNonSegueAction;

@end

NS_ASSUME_NONNULL_END
