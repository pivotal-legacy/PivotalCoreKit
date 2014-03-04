#import "UIImage+PivotalCore.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation UIImage (PivotalCore)

- (CGFloat)aspectRatio {
    return self.size.width / self.size.height;
}

+ (UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale {
    UIImage *tempImage = [UIImage imageWithData:data];
    if (scale == 1.0) {
        return tempImage;
    }
    CGImageRef imageRef = [tempImage CGImage];
    return [[[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:tempImage.imageOrientation] autorelease];
}

- (UIImage *)resizedToSize:(CGSize)newSize {
    CGFloat scale = self.scale;
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * scale, newSize.height * scale));
//    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;

    // Build a context that's the same dimensions as the new size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL, newRect.size.width, newRect.size.height, 8, 4 * newRect.size.width,
                                                colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);

    // Rotate and/or flip the image if required by its orientation
//    CGContextConcatCTM(bitmap, transform);

    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationDefault);

    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, imageRef);

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);

    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:self.imageOrientation];

    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);

    return newImage;
}

- (UIImage *)aspectFitResizedToSize:(CGSize)newSize {
    CGFloat oldAspectRatio = self.aspectRatio;
    CGFloat newAspectRatio = newSize.width / newSize.height;
    if (oldAspectRatio < newAspectRatio) {
        return [self resizedToSize:CGSizeMake(newSize.height * oldAspectRatio, newSize.height)];
    } else {
        return [self resizedToSize:CGSizeMake(newSize.width, newSize.width / oldAspectRatio)];
    }
}

- (UIImage *)aspectFillResizedToSizeNoCrop:(CGSize)newSize {
    CGFloat oldAspectRatio = self.aspectRatio;
    CGFloat newAspectRatio = newSize.width / newSize.height;
    if (oldAspectRatio < newAspectRatio) {
        return [self resizedToSize:CGSizeMake(newSize.width, newSize.width / oldAspectRatio)];
    } else {
        return [self resizedToSize:CGSizeMake(newSize.height * oldAspectRatio, newSize.height)];
    }
}

- (UIImage *)croppedToRect:(CGRect)cropRect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage,
                                                       CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(self.scale, self.scale)));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)aspectFillResizedToSize:(CGSize)newSize {
    UIImage *resizedImage = [self aspectFillResizedToSizeNoCrop:newSize];
    return [resizedImage croppedToRect:CGRectMake((resizedImage.size.width - newSize.width)/2.0,
                                                  (resizedImage.size.height - newSize.height)/2.0,
                                                  newSize.width, newSize.height)];
}

- (UIImage *)imageWithRoundedCorners:(CGFloat)cornerRadius {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    CGRect imageRect = CGRectMake(0, 0, image.size.width * self.scale, image.size.height * self.scale);
    size_t fw = CGRectGetWidth(imageRect);
    size_t fh = CGRectGetHeight(imageRect);
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 fw,
                                                 fh,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, 0);
    CGContextScaleCTM(context, 1, 1);
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, cornerRadius);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, cornerRadius);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, cornerRadius);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, cornerRadius);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    CGContextClosePath(context);
    CGContextClip(context);

    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, imageRect, image.CGImage);

    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(clippedImage);

    return roundedImage;
}

// Copied and modified from http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }

    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);

    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha scale:self.scale orientation:self.imageOrientation];

    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);

    return imageWithAlpha;
}

@end

#pragma clang diagnostic pop
