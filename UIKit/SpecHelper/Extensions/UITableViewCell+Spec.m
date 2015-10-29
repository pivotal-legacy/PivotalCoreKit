#import "UITableViewCell+Spec.h"
#import "UIView+Spec.h"
#import "UIControl+Spec.h"
#import "PCKPrototypeCellInstantiatingDataSource.h"

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
    [tableView layoutIfNeeded];
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
        if (tableView.allowsMultipleSelection && self.isSelected) {
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
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending &&
            [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
            UIView *cellScrollView = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellScrollView"]] firstObject];
            deleteAccessoryControl = [[cellScrollView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellEditControl"]] firstObject];
        } else {
            deleteAccessoryControl = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className ENDSWITH %@", @"EditControl"]] firstObject];
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
        if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIView *cellDeleteView = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellDeleteConfirmationView"]] firstObject];;
            deleteConfirmationControl = (UIControl *)[[cellDeleteView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"_UITableViewCellActionButton"]] firstObject];
        } else if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIView *cellScrollView = [[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellScrollView"]] firstObject];
            UIView *cellDeleteView = cellScrollView.subviews[0];
            deleteConfirmationControl = (UIControl *)[[cellDeleteView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellDeleteConfirmationButton"]] firstObject];
        } else {
            deleteConfirmationControl = (UIControl *)[[self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"className MATCHES %@", @"UITableViewCellDeleteConfirmationControl"]] firstObject];
        }

        [deleteConfirmationControl tap];
    }
}

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                      tableViewKeyPath:(NSString *)tableViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier {
    NSAssert(storyboard, @"Must provide a storyboard");
    NSAssert([cellIdentifier length] > 0, @"Must provide a cell identifier");

    UIViewController *viewController = viewControllerIdentifier ? [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier] : [storyboard instantiateInitialViewController];
    NSAssert(viewController, @"Could not find the view controller");

    [viewController view];

    UITableView *tableView = tableViewKeyPath ? [viewController valueForKeyPath:tableViewKeyPath] : [viewController.view firstSubviewOfClass:[UITableView class]];
    NSAssert(tableView, @"Could not find the table view");

    PCKPrototypeCellInstantiatingDataSource *dataSource = [[[PCKPrototypeCellInstantiatingDataSource alloc] initWithTableView:tableView] autorelease];
    return [dataSource tableViewCellWithIdentifier:cellIdentifier];

}

@end
