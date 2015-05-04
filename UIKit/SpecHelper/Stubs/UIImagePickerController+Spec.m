#import "UIImagePickerController+Spec.h"
#import <objc/runtime.h>

static BOOL isCameraAvailable__, isPhotoLibraryAvailable__, isSavedPhotosAlbumAvailable__;
static const NSNumber *cameraDevice__;

@implementation UIImagePickerController (Spec)

+ (void)afterEach {
    [self reset];
}

+ (void)reset {
    isCameraAvailable__ = isPhotoLibraryAvailable__ = isSavedPhotosAlbumAvailable__ = YES;
}

+ (void)initialize {
    [self reset];
}

+ (void)setPhotoLibraryAvailable:(BOOL)available {
    isPhotoLibraryAvailable__ = available;
}

+ (void)setCameraAvailable:(BOOL)available {
    isCameraAvailable__ = available;
}

+ (void)setSavedPhotosAlbumAvailable:(BOOL)available {
    isSavedPhotosAlbumAvailable__ = available;
}

- (void)setCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice {
    objc_setAssociatedObject(self, &cameraDevice__, [NSNumber numberWithInteger:cameraDevice],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImagePickerControllerCameraDevice)cameraDevice {
    return (UIImagePickerControllerCameraDevice)[objc_getAssociatedObject(self, &cameraDevice__) integerValue];
}

#pragma mark - Overrides

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType {
    switch (sourceType) {
        case UIImagePickerControllerSourceTypePhotoLibrary:
            return isPhotoLibraryAvailable__;
        case UIImagePickerControllerSourceTypeCamera:
            return isCameraAvailable__;
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
            return isSavedPhotosAlbumAvailable__;
        default:
            return NO;
    }
}
#pragma clang diagnostic pop
@end
