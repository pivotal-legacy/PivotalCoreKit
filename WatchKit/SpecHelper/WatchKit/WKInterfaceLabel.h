#import <UIKit/UIKit.h>
#import "TestableWKInterfaceLabel.h"


@interface WKInterfaceLabel : NSObject <TestableWKInterfaceLabel>

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSAttributedString *attributedText;
@property (nonatomic) UIColor *textColor;

@end
