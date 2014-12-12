#import <Foundation/Foundation.h>

@protocol TestableWKInterfaceSwitch <NSObject>

- (void)setEnabled:(BOOL)enabled;
- (void)setOn:(BOOL)on;

@optional

- (BOOL)enabled;
- (BOOL)on;
- (void)tap;

@end
