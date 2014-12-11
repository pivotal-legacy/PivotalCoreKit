#import "CorgisController.h"

@interface CorgisController ()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;

@end

@implementation CorgisController

-(id)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self) {
        self.image.image = context;
    }
    return self;
}

@end
