#import "OuterView.h"

@implementation OuterView

- (void)dealloc {
    [_innerView release];
    [_subview release];
    [_horizontalSpace release];
    [_verticalSpace release];
    [super dealloc];
}
@end
