#import "WKInterfaceImage.h"


@implementation WKInterfaceImage

-(void)setImage:(id)image {
    _image = [image isKindOfClass:[UIImage class]] ? image : [UIImage imageNamed:image];
}

@end
