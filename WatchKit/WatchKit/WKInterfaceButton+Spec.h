#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;
@class WKInterfaceController;

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceButton (Spec)

@property (nonatomic, readonly, nullable) NSString *title;
@property (nonatomic, readonly, nullable) UIColor *color;
@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly, nullable) NSString *action;
@property (nonatomic, readonly, nullable) PCKFakeSegue *segue;
@property (nonatomic, readonly, nullable) WKInterfaceGroup *content;

@end

@interface WKInterfaceButton (Spec2)

@property (nonatomic, weak, nullable) WKInterfaceController *controller;

- (void)triggerNonSegueAction;

@end

NS_ASSUME_NONNULL_END
