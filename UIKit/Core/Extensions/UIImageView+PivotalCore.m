#import "UIImageView+PivotalCore.h"

@implementation UIImageView (PivotalCore)

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName {
    return [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
}

@end
