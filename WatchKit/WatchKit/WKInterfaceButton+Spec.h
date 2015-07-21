#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;
@class WKInterfaceController;


@interface WKInterfaceButton (Spec)

@property (nonatomic, weak) WKInterfaceController *controller;

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (NSString *)action;
- (PCKFakeSegue *)segue;
- (WKInterfaceGroup *)content;

- (void)triggerNonSegueAction;

@end
