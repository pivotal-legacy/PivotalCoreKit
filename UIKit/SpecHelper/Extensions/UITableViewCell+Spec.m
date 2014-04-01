#import "UITableViewCell+Spec.h"
#import "UIControl+Spec.h"

@interface UIStoryboardSegueTemplate
- (id)identifier;
- (id)viewController;
@end

@interface UITableView (ApplePrivateMethods)
- (BOOL)highlightRowAtIndexPath:(id)arg1 animated:(BOOL)arg2 scrollPosition:(int)arg3;
- (void)unhighlightRowAtIndexPath:(id)arg1 animated:(BOOL)arg2;
- (void)_selectRowAtIndexPath:(id)arg1 animated:(BOOL)arg2 scrollPosition:(int)arg3 notifyDelegate:(BOOL)arg4;
- (void)_deselectRowAtIndexPath:(id)arg1 animated:(BOOL)arg2 notifyDelegate:(BOOL)arg3;
@end

@interface UITableViewCell ()
- (id)selectionSegueTemplate;
@end

@implementation UITableViewCell (Spec)

- (void)tap {
    UIView *currentView = self;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UITableView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be in a table view in order to be tapped!");
    UITableView *tableView = (UITableView *)currentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];

    BOOL shouldContinueSelectionAfterHighlighting = YES;
    if (self.isHighlighted) {
        [tableView unhighlightRowAtIndexPath:indexPath animated:NO];
    } else {
        // highlightRowAtIndexPath:animated:scrollPosition: checks the delegate's tableView:shouldHightRowAtIndexPath: (if the delegate responds to it).
        // If highlightRowAtIndexPath:animated:scrollPosition: returns false, the cell should not continue with the selection process.
        shouldContinueSelectionAfterHighlighting = [tableView highlightRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }

    if (shouldContinueSelectionAfterHighlighting) {
        if (self.isSelected) {
            [tableView _deselectRowAtIndexPath:indexPath animated:NO notifyDelegate:YES];
        } else {
            [tableView _selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle notifyDelegate:YES];
        }
    }
}

- (void)tapDeleteAccessory {
    UIControl *deleteAccessoryControl;

    UIView *currentView = self;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UITableView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be in a table view in order to be tapped!");
    UITableView *tableView = (UITableView *)currentView;
    if (!tableView.editing) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Table view must be in editing mode in order to tap delete accessory" userInfo:nil];
    } else {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIView *cellScrollView = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellScrollView"]] firstObject];
            deleteAccessoryControl = [[cellScrollView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellEditControl"]] firstObject];
        } else {
            deleteAccessoryControl = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellEditControl"]] firstObject];
        }

        [deleteAccessoryControl sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)tapDeleteConfirmation {
    UIControl *deleteConfirmationControl;

    UIView *currentView = self;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UITableView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be in a table view in order to be tapped!");
    UITableView *tableView = (UITableView *)currentView;

    if (!tableView.editing) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Table view must be in editing mode in order to tap delete confirmation" userInfo:nil];
    } else if (!self.showingDeleteConfirmation) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Delete confirmation must be visible in order to tap it" userInfo:nil];
    } else {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIView *cellScrollView = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellScrollView"]] firstObject];
            UIView *cellDeleteView = cellScrollView.subviews[0];
            deleteConfirmationControl = (UIControl *)[[cellDeleteView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellDeleteConfirmationButton"]] firstObject];
        } else {
            deleteConfirmationControl = (UIControl *)[[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellDeleteConfirmationControl"]] firstObject];
        }

        [deleteConfirmationControl tap];
    }
}



@end
