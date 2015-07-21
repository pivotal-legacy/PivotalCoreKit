#import "WKInterfaceButton.h"


@class PCKFakeSegue;
@class WKInterfaceGroup;


@interface WKInterfaceButton (Spec)

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (NSString *)action;
- (PCKFakeSegue *)segue;
- (WKInterfaceGroup *)content;

@end
