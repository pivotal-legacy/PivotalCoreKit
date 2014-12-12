#import "WKInterfaceObject.h"
#import "TestableWKInterfaceSeparator.h"


@interface WKInterfaceSeparator : WKInterfaceObject <TestableWKInterfaceSeparator>

@property (nonatomic) UIColor *color;

@end
