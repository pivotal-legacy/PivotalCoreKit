#import "UIImage+Spec.h"

@implementation UIImage (Spec)

- (BOOL)isEqualToByBytes:(UIImage *)otherImage {
    CFDataRef imagePixelsData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    CFDataRef otherImagePixelsData = CGDataProviderCopyData(CGImageGetDataProvider(otherImage.CGImage));
    
    BOOL comparison = CFEqual(imagePixelsData, otherImagePixelsData);
    
    CFRelease(imagePixelsData);
    CFRelease(otherImagePixelsData);
    
    return comparison;
}

@end
