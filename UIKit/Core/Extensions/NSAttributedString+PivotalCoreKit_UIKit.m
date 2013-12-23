#import "NSAttributedString+PivotalCoreKit_UIKit.h"

@implementation NSAttributedString (PivotalCoreKit_UIKit)

- (CGFloat)heightWithWidth:(CGFloat)width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                              context:nil].size.height;
}

@end
