#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;
@class WKInterfaceController;


@interface WKInterfaceButton (Spec)

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) NSString *action;
@property (nonatomic, readonly) PCKFakeSegue *segue;
@property (nonatomic, readonly) WKInterfaceGroup *content;

@end

@interface WKInterfaceButton (Spec2)

@property (nonatomic, weak) WKInterfaceController *controller;

- (void)triggerNonSegueAction;

@end
