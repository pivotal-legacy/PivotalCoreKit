#import "WKInterfaceDevice.h"

@interface PCKMessageCapturer ()

+ (WKInterfaceDevice *)currentDevice NS_REQUIRES_SUPER;

- (BOOL)addCachedImage:(UIImage *)image name:(NSString *)name NS_REQUIRES_SUPER;
- (BOOL)addCachedImageWithData:(NSData *)imageData name:(NSString *)name NS_REQUIRES_SUPER;
- (void)removeCachedImageWithName:(NSString *)name NS_REQUIRES_SUPER;
- (void)removeAllCachedImages NS_REQUIRES_SUPER;

- (void)playHaptic:(WKHapticType)type NS_REQUIRES_SUPER;

@end

@interface WKInterfaceDevice ()

@property(nonatomic) CGRect screenBounds;
@property(nonatomic) CGFloat screenScale;
@property(nonatomic, copy) NSString *preferredContentSizeCategory;
@property(nonatomic, strong) NSDictionary *cachedImages;

@end

@implementation WKInterfaceDevice

+ (WKInterfaceDevice *)currentDevice
{
    [super currentDevice];
    return [[WKInterfaceDevice alloc] init];
}

- (BOOL)addCachedImage:(UIImage *)image name:(NSString *)name
{
    return [super addCachedImage:image name:name];
}

- (BOOL)addCachedImageWithData:(NSData *)imageData name:(NSString *)name
{
    return [super addCachedImageWithData:imageData name:name];
}

- (void)removeCachedImageWithName:(NSString *)name
{
    [super removeCachedImageWithName:name];
}

- (void)removeAllCachedImages
{
    [super removeAllCachedImages];
}

- (void)playHaptic:(WKHapticType)type {
    [super playHaptic:type];
}

@end
