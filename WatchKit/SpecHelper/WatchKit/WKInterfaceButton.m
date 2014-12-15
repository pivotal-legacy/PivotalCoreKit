#import "WKInterfaceButton.h"
#import "WKInterfaceController.h"
#import "UIColor+PCK_StringToColor.h"
#import "FakeSegue.h"


@interface WKInterfaceButton ()

@property (nonatomic, copy) NSString *action;
@property (nonatomic) FakeSegue *segue;

@end


static NSDictionary *typeStringToEnumType;


@implementation WKInterfaceButton

+ (void)initialize
{
    typeStringToEnumType = @{
                             @"push": @(FakeSegueTypePush),
                             @"present": @(FakeSegueTypeModal)
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

- (void)setTitleColor:(id)color
{
    _color = [color isKindOfClass:[UIColor class]] ? color : [UIColor colorWithNameOrHexValue:color];
}

- (void)setSegue:(NSDictionary *)segueDictionary
{
    NSString *destinationIdentifier = segueDictionary[@"destination"];
    NSString *typeString = segueDictionary[@"type"];
    NSNumber *enumType = typeStringToEnumType[segueDictionary[@"type"]];
    if (enumType) {
        FakeSegueType type = [enumType unsignedIntegerValue];
        _segue = [[FakeSegue alloc] initWithDestinationIdentifier:destinationIdentifier type:type];
    }
    else {
        [NSException raise:NSInvalidArgumentException
                    format:@"We encountered a new segue type, '%@', in WatchKit.  This probably means that there is a new version of WatchKit that this library needs to be updated to support.", typeString];
    }
}

@end
