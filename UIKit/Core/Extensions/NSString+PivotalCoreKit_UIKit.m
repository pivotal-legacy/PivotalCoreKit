#import "NSString+PivotalCoreKit_UIKit.h"

@implementation NSString (PivotalCoreKit_UIKit)

- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].height;
    }
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                             attributes:@{NSFontAttributeName: font}
                                context:nil].size.height;
}

@end
