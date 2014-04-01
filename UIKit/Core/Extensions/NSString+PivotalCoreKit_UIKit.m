#import "NSString+PivotalCoreKit_UIKit.h"

@implementation NSString (PivotalCoreKit_UIKit)

- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font
{
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName: font}
                                  context:nil].size.height;
    }
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

@end
