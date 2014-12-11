#import <Foundation/Foundation.h>
#import "TestableWKInterfaceButton.h"


@interface WKInterfaceButton : NSObject <TestableWKInterfaceButton>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *color;
@property (nonatomic) BOOL enabled;

@end
