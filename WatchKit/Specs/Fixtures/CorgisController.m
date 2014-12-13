#import "CorgisController.h"


@interface CorgisController ()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;

@end


@implementation CorgisController

#pragma mark - WKInterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    self.image.image = context;
}

@end
