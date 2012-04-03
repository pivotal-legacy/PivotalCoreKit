#import "UIImage+PivotalCore.h"

@implementation UIImage (PivotalCore)

+ (UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale {
    UIImage *tempImage = [UIImage imageWithData:data];
    if (scale == 1.0) {
        return tempImage;
    }
    CGImageRef imageRef = [tempImage CGImage];
    return [[[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:tempImage.imageOrientation] autorelease];
}

@end
