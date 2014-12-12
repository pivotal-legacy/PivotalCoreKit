#import "WKInterfaceObject.h"
#import "TestableWKInterfaceLabel.h"


@interface WKInterfaceLabel : WKInterfaceObject <TestableWKInterfaceLabel>

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSAttributedString *attributedText;
@property (nonatomic) UIColor *textColor;

@end
