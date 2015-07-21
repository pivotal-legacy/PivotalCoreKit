#import "InterfaceController.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *programmaticLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceSeparator *separator;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *actionButton;
@property (weak, nonatomic) IBOutlet WKInterfaceDate *date;
@property (weak, nonatomic) IBOutlet WKInterfaceSwitch *theSwitch;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *noActionButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *seguePushButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *segueModalButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *groupButton;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *enabledSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *disabledSlider;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *singleGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *nestedGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *timer;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *corgiImageInSingleGroup;
@property (nonatomic) id context;

@property (nonatomic) NSUInteger tapCount;

@end


@implementation InterfaceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.programmaticLabel setText:@"My Initial Title"];
    }
    return self;
}

#pragma mark - WKInterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    self.context = context;
}

- (void)willActivate
{
    [super willActivate];
    [self.titleLabel setText:@"My Special Text"];
}

- (void)didDeactivate
{
    [super didDeactivate];
    self.actionButton.enabled = NO;
    self.theSwitch.enabled = NO;
    self.theSwitch.on = NO;
}

- (IBAction)didTapButton
{
    self.tapCount += 1;
}

@end



