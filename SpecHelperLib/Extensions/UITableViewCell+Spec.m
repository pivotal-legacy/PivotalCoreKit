#import "UITableViewCell+Spec.h"

@implementation UITableViewCell (Spec)

- (void)tap {
    NSAssert(self.superview, @"Cell doesn't have a superview!");
    UITableView *tableView = (UITableView *)self.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];

    if ([tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        indexPath = [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }

    if (indexPath != nil) {
        [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
