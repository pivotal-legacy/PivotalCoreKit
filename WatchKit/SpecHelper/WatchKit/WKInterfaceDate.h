#import "WKInterfaceObject.h"
#import "TestableWKInterfaceDate.h"

@interface WKInterfaceDate : WKInterfaceObject <TestableWKInterfaceDate>

@property (nonatomic) UIColor *textColor;
@property (nonatomic, copy) NSString *format;

@end
