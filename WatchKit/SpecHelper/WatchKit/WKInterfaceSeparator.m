#import "WKInterfaceSeparator.h"


static NSSet *colorNames;


@implementation WKInterfaceSeparator

+ (void)initialize
{
    if ([self class] == [WKInterfaceSeparator class]) {
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
        colorNames = [NSSet setWithArray:colorNameArray];
    }
}


-(void)setColor:(NSString *)color
{
    if ([colorNames containsObject:color]) {
        NSString* colorString = [NSString stringWithFormat:@"%@Color", color];
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        _color = [[UIColor class] performSelector:NSSelectorFromString(colorString)];
#       pragma clang diagnostic pop
    }
    else {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:color];
        [scanner scanHexInt:&rgbValue];
        _color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                                 green:((rgbValue & 0xFF00) >> 8) / 255.0
                                  blue:(rgbValue & 0xFF) / 255.0
                                 alpha:1.0];
    }
}

@end
