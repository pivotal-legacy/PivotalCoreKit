#import "WKInterfaceImage.h"


@interface WKInterfaceImage ()

@property (nonatomic) UIImage *image;

@end


@implementation WKInterfaceImage

-(void)setImage:(id)image {
    _image = [image isKindOfClass:[UIImage class]] ? image : [UIImage imageNamed:image];
}

@end
