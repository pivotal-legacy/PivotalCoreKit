#import "UIColor+PCK_StringToColor.h"


@implementation UIColor (PCK_StringToColor)

+ (UIColor *)colorWithNameOrHexValue:(NSString *)nameOrHexValue
{
    NSArray *colorNameArray = @[@"black",
                                @"darkGray",
                                @"lightGray",
                                @"white",
                                @"gray",
                                @"red",
                                @"green",
                                @"blue",
                                @"cyan",
                                @"yellow",
                                @"magenta",
                                @"orange",
                                @"purple",
                                @"brown",
                                @"clear"];

    if ([colorNameArray containsObject:nameOrHexValue]) {
        NSString* colorString = [NSString stringWithFormat:@"%@Color", nameOrHexValue];
        __autoreleasing id color = nil;
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        color = [[UIColor class] performSelector:NSSelectorFromString(colorString)];
#       pragma clang diagnostic pop
        return color;
    }
    else {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:nameOrHexValue];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                               green:((rgbValue & 0xFF00) >> 8) / 255.0f
                                blue:(rgbValue & 0xFF) / 255.0f
                               alpha:1.0];
    }
}

@end
