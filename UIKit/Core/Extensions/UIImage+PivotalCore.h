#import <UIKit/UIKit.h>

@interface UIImage (PivotalCore)

- (CGFloat)aspectRatio;
+ (UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;
- (UIImage *)resizedToSize:(CGSize)newSize;
- (UIImage *)aspectFitResizedToSize:(CGSize)newSize;
- (UIImage *)aspectFillResizedToSizeNoCrop:(CGSize)newSize;
- (UIImage *)croppedToRect:(CGRect)cropRect;
- (UIImage *)aspectFillResizedToSize:(CGSize)newSize;
- (UIImage *)imageWithRoundedCorners:(CGFloat)cornerRadius;

@end
