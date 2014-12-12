#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceSeparator *separator;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *actionButton;
@property (weak, nonatomic) IBOutlet WKInterfaceDate *date;
@property (weak, nonatomic) IBOutlet WKInterfaceSwitch *theSwitch;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *noActionButton;
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
    self.actionButton.enabled = NO;
    self.theSwitch.enabled = NO;
    self.theSwitch.on = NO;
}

- (IBAction)didTapButton {
    [self.context appendString:@"Tweet."];
}

@end



