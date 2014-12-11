#import <UIKit/UIKit.h>

@protocol TestableWKInterfaceImage <NSObject>

-(void)setImage:(UIImage *)image;

@optional

-(UIImage *)image;

@end
