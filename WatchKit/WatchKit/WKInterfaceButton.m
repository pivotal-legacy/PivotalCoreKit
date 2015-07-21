#import "WKInterfaceButton.h"
#import "WKInterfaceController.h"
#import "UIColor+PCK_StringToColor.h"
#import "PCKFakeSegue.h"
#import "WKInterfaceGroup.h"


@interface WKInterfaceObject ()

- (void)setTitle:(NSString *)title NS_REQUIRES_SUPER;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle NS_REQUIRES_SUPER;

- (void)setColor:(UIColor *)color NS_REQUIRES_SUPER;
- (void)setBackgroundImage:(UIImage *)image NS_REQUIRES_SUPER;
- (void)setBackgroundImageData:(NSData *)imageData NS_REQUIRES_SUPER;
- (void)setBackgroundImageNamed:(NSString *)imageName NS_REQUIRES_SUPER;

- (void)setEnabled:(BOOL)enabled NS_REQUIRES_SUPER;

@end


@interface WKInterfaceButton ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *color;
@property (nonatomic) BOOL enabled;
@property (nonatomic, copy) NSString *action;
@property (nonatomic) PCKFakeSegue *segue;
@property (nonatomic) WKInterfaceGroup *content;

@end


static NSDictionary *typeStringToEnumType;


@implementation WKInterfaceButton

+ (void)initialize
{
    typeStringToEnumType = @{
                             @"push": @(PCKFakeSegueTypePush),
                             @"present": @(PCKFakeSegueTypeModal)
                             };
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // The `enabled` property of a button in storyboard plist representation
        // only appears if the button has been disabled.  Otherwise any button
        // on an interface controller will be enabled.
        //
        self.enabled = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [super setTitle:title];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    [super setAttributedTitle:attributedTitle];
}

- (void)setColor:(UIColor *)color
{
    [self setTitleColor:color];
    [super setColor:color];
}

- (void)setTitleColor:(id)color
{
    _color = [color isKindOfClass:[UIColor class]] ? color : [UIColor colorWithNameOrHexValue:color];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [super setBackgroundImage:image];
}

- (void)setBackgroundImageData:(NSData *)imageData
{
    [super setBackgroundImageData:imageData];
}

- (void)setBackgroundImageNamed:(NSString *)imageName
{
    [super setBackgroundImageNamed:imageName];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [super setEnabled:enabled];
}

- (void)setSegue:(NSDictionary *)segueDictionary
{
    NSString *destinationIdentifier = segueDictionary[@"destination"];
    NSString *typeString = segueDictionary[@"type"];
    NSNumber *enumType = typeStringToEnumType[segueDictionary[@"type"]];
    if (enumType) {
        PCKFakeSegueType type = [enumType unsignedIntegerValue];
        _segue = [[PCKFakeSegue alloc] initWithDestinationIdentifier:destinationIdentifier type:type];
    }
    else {
        [NSException raise:NSInvalidArgumentException
                    format:@"We encountered a new segue type, '%@', in WatchKit.  This probably means that there is a new version of WatchKit that this library needs to be updated to support.", typeString];
    }
}

@end
