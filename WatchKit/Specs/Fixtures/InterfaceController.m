#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceSeparator *separator;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button;
@property (nonatomic) NSMutableString* context;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        self.context = context;
    }
    return self;
}

#pragma mark - WKInterfaceController

- (void)willActivate {
    [self.titleLabel setText:@"My Special Text"];
}

- (void)didDeactivate {
    self.button.enabled = NO;
}

- (IBAction)didTapButton {
    [self.context appendString:@"Tweet."];
}

@end



