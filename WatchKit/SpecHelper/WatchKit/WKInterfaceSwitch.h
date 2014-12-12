#import "WKInterfaceObject.h"
#import "TestableWKInterfaceSwitch.h"

@interface WKInterfaceSwitch : WKInterfaceObject <TestableWKInterfaceSwitch>

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL on;

@end
