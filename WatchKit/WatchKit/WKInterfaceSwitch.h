#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceSwitch : WKInterfaceObject

- (void)setEnabled:(BOOL)enabled;
- (void)setOn:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
