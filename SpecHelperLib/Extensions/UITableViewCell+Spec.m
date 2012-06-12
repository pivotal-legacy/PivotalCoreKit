#import "UITableViewCell+Spec.h"

@implementation UITableViewCell (Spec)

- (void)tap {
    NSAssert(self.superview, @"Cell doesn't have a superview!");
    UITableView *tableView = (UITableView *)self.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
