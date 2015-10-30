#import "WKInterfaceLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceLabel (Spec)

@property (nonatomic, readonly, nullable) NSString *text;
@property (nonatomic, readonly, nullable) UIColor *textColor;
@property (nonatomic, readonly, nullable) NSAttributedString *attributedText;

@end

NS_ASSUME_NONNULL_END
