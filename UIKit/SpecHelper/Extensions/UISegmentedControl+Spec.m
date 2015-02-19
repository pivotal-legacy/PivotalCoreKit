#import "UISegmentedControl+Spec.h"

@implementation UISegmentedControl (Spec)

- (void)selectSegmentAtIndex:(NSInteger)index {
    [self runAssertionsWithIndex:index];

    self.selectedSegmentIndex = index;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Private

- (void)runAssertionsWithIndex:(NSInteger)index {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle an invisible segmented control" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle a disabled segmented control" userInfo:nil] raise];
    }
    if (index >= self.numberOfSegments) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't select a segment that does not exist" userInfo:nil] raise];
    }
}

@end
