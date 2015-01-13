#import "WKInterfaceButton.h"


@class PCKFakeSegue;


@interface WKInterfaceButton (Spec)

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (NSString *)action;
- (PCKFakeSegue *)segue;

@end
