#import "UIImagePickerController+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

static BOOL isCameraAvailable__, isPhotoLibraryAvailable__, isSavedPhotosAlbumAvailable__;
static const NSNumber *cameraDevice__;

@implementation UIImagePickerController (Spec)

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
    [PCKMethodRedirector redirectPCKReplaceSelectorsForClass:self];
    [PCKMethodRedirector redirectPCKReplaceSelectorsForClass:objc_getMetaClass(class_getName(self))];
}

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

- (void)pck_replace_setCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice {
    objc_setAssociatedObject(self, &cameraDevice__, [NSNumber numberWithInteger:cameraDevice],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Overrides

- (UIImagePickerControllerCameraDevice)pck_replace_cameraDevice {
    return (UIImagePickerControllerCameraDevice)[objc_getAssociatedObject(self, &cameraDevice__) integerValue];
}

+ (BOOL)pck_replace_isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType {
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
@end
