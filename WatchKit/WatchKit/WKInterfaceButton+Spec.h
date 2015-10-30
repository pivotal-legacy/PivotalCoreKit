#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;
@class WKInterfaceController;


@interface WKInterfaceButton (Spec)

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (NSString *)action;
- (PCKFakeSegue *)segue;
- (WKInterfaceGroup *)content;

@end

@interface WKInterfaceButton (Spec2)

@property (nonatomic, weak) WKInterfaceController *controller;

- (void)triggerNonSegueAction;

@end
