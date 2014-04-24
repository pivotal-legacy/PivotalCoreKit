#import "InnerView.h"

@implementation InnerView

- (void)dealloc {
    [_subview release];
    [_anotherSubview release];
    [_verticalSpace release];
    [_horizontalSpace release];
    [super dealloc];
}
@end
