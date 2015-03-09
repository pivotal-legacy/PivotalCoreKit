#import <PivotalCoreKit/UIKit+PivotalCore.h>

#import "UIKitCore.h"

@interface UIKitCore ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UISwitch *aSwitch;
@end

@implementation UIKitCore

- (instancetype)init {
    if (self = [super init]) {
        self.aSwitch = [[UISwitch alloc] init];
    }
    return self;
}

- (void)addImageToImageView {
    self.imageView = [UIImageView imageViewWithImageNamed:@"pivotal"];
}

@end
