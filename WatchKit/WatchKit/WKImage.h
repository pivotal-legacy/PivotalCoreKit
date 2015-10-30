#import <Foundation/Foundation.h>
#import "WKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class UIImage;

@interface WKImage : NSObject <NSCopying, NSSecureCoding>

+ (instancetype)imageWithImage:(UIImage *)image;
+ (instancetype)imageWithImageData:(NSData *)imageData;
+ (instancetype)imageWithImageName:(NSString *)imageName;

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nullable) UIImage *image;
@property (readonly, nullable) NSData *imageData;
@property (readonly, nullable) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
