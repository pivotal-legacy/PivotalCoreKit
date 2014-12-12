#import "WKInterfaceObject.h"
#import "TestableWKInterfaceButton.h"


@interface WKInterfaceButton : WKInterfaceObject <TestableWKInterfaceButton>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *color;
@property (nonatomic) BOOL enabled;

@end
