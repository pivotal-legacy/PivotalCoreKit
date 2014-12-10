#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
    }
    return self;
}

- (void)willActivate {
    [self.titleLabel setText:@"My Special Text"];
}

- (void)didDeactivate {
    
}

@end



