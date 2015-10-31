#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImagePickerController (Spec)

+ (void)setPhotoLibraryAvailable:(BOOL)available;
+ (void)setCameraAvailable:(BOOL)available;
+ (void)setSavedPhotosAlbumAvailable:(BOOL)available;

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;

@end

NS_ASSUME_NONNULL_END
