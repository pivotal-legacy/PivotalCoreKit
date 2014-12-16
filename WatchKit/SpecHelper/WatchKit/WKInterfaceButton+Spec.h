#import "WKInterfaceButton.h"


@class FakeSegue;


@interface WKInterfaceButton (Spec)

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (NSString *)action;
- (FakeSegue *)segue;

@end
