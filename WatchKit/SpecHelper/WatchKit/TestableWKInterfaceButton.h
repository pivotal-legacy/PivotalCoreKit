#import <UIKit/UIKit.h>


@class FakeSegue;


@protocol TestableWKInterfaceButton <NSObject>

- (void)setTitle:(NSString *)title;
- (void)setColor:(UIColor *)color;
- (void)setEnabled:(BOOL)enabled;

@optional

@property (nonatomic, readonly) FakeSegue *segue;

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;
- (SEL)action;
- (void)tap;

@end
