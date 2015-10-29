#import "Cedar.h"
#import "UITableViewCell+Spec.h"
#import "PrototypeCellObjects.h"

#if TARGET_OS_TV
#define PLATFORM_HAS_DELETE_CONFIRMATION 0
#else
#define PLATFORM_HAS_DELETE_CONFIRMATION 1
#endif

@interface SpecTableViewController : UITableViewController
@property (nonatomic) BOOL shouldHighlightRows;
@property (nonatomic, retain) NSIndexPath *lastSelectedIndexPath;
@end

@implementation SpecTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"Cell"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.shouldHighlightRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastSelectedIndexPath = indexPath;
}

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UITableViewCell_SpecSpec)

describe(@"UITableViewCell+Spec", ^{
    __block SpecTableViewController *controller;
    __block UITableViewCell *cell;

    beforeEach(^{
        controller = [[SpecTableViewController alloc] initWithStyle:UITableViewStylePlain];
        controller.shouldHighlightRows = YES;
        controller.view should_not be_nil;
        [controller.view layoutIfNeeded];

        cell = controller.tableView.visibleCells[0];
    });

    describe(@"-tap", ^{
        context(@"for a single selection table view", ^{
            beforeEach(^{
                [cell tap];
            });

            it(@"should result in the cell being selected", ^{
                [controller.tableView indexPathForSelectedRow] should equal([controller.tableView indexPathForCell:cell]);
            });

            it(@"should highlight the cell", ^{
                cell.isHighlighted should be_truthy;
            });

            it(@"should deselect the cell if another cell is tapped", ^{
                [controller.tableView.visibleCells[1] tap];

                [controller.tableView indexPathForSelectedRow] should_not equal([controller.tableView indexPathForCell:cell]);
            });

            it(@"should call the delegate method when the same cell is tapped", ^{
                controller.lastSelectedIndexPath = nil;

                [cell tap];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                controller.lastSelectedIndexPath should equal(indexPath);
                controller.tableView.indexPathsForSelectedRows should equal(@[indexPath]);
            });
        });

        context(@"for a multiple selection table view", ^{
            beforeEach(^{
                [controller.tableView setAllowsMultipleSelection:YES];
                [cell tap];
            });

            it(@"should result in the cell being selected", ^{
                [controller.tableView indexPathForSelectedRow] should equal([controller.tableView indexPathForCell:cell]);
            });

            it(@"should highlight the cell", ^{
                cell.isHighlighted should be_truthy;
            });

            it(@"should deselect the cell if tapped again", ^{
                [cell tap];

                [controller.tableView indexPathsForSelectedRows] should_not contain([controller.tableView indexPathForCell:cell]);
            });

            it(@"should unhighlight the cell if tapped again", ^{
                [cell tap];

                cell.isHighlighted should be_falsy;
            });

            it(@"should not deselect the cell if another cell is tapped", ^{
                [controller.tableView.visibleCells[1] tap];

                [controller.tableView indexPathsForSelectedRows] should equal(@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]]);
            });

            it(@"should not call the delegate method when the same cell is tapped", ^{
                controller.lastSelectedIndexPath = nil;

                [cell tap];

                controller.lastSelectedIndexPath should be_nil;
                controller.tableView.indexPathsForSelectedRows should be_empty;
            });
        });

        context(@"for a table with highlighting turned off", ^{
            beforeEach(^{
                controller.shouldHighlightRows = NO;
                [cell tap];
            });

            it(@"should not result in the cell being selected", ^{
                [controller.tableView indexPathForSelectedRow] should be_nil;
            });

           it(@"should not highlight the cell", ^{
                cell.isHighlighted should be_falsy;
            });
        });

        context(@"for a storyboard cell", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UITableViewCell" bundle:nil];
                controller = [storyboard instantiateInitialViewController];
                controller.view should_not be_nil;
                [controller viewWillAppear:NO];

                cell = controller.tableView.visibleCells.firstObject;
                controller.presentedViewController should be_nil;
                [cell tap];
            });

            it(@"should perform the segue on the table view controller (presenting a modal view controller)", ^{
                controller.presentedViewController should_not be_nil;
            });
        });
    });

    describe(@"-tapDeleteAccessory", ^{
        context(@"table view is not in editing mode", ^{
            beforeEach(^{
                [controller.tableView setEditing:NO animated:NO];
            });

            it(@"should raise an exception", ^{
                ^{ [cell tapDeleteAccessory]; } should raise_exception;
            });
        });

        context(@"table view is in editing mode", ^{
            beforeEach(^{
                [controller.tableView setEditing:YES animated:NO];

                spy_on(controller.tableView.dataSource);
                [cell tapDeleteAccessory];
            });

#if PLATFORM_HAS_DELETE_CONFIRMATION
            it(@"should expose the delete confirmation button", ^{
                cell.showingDeleteConfirmation should be_truthy;
            });
#else
            it(@"should call the appropriate handler", ^{
                controller.tableView.dataSource should have_received(@selector(tableView:commitEditingStyle:forRowAtIndexPath:)).with(controller.tableView, UITableViewCellEditingStyleDelete, [NSIndexPath indexPathForRow:0 inSection:0]);
            });
#endif
        });

    });

    describe(@"-tapDeleteConfirmation", ^{
        context(@"table view is not in editing mode", ^{
            beforeEach(^{
                [controller setEditing:NO animated:NO];
            });

            it(@"should raise an exception", ^{
                ^{ [cell tapDeleteConfirmation]; } should raise_exception;
            });
        });

        context(@"table view is in editing mode", ^{
            beforeEach(^{
                [controller setEditing:YES animated:NO];
            });

#if PLATFORM_HAS_DELETE_CONFIRMATION
            context(@"delete confirmation is visible", ^{
                beforeEach(^{
                    spy_on(controller.tableView.dataSource);

                    [cell tapDeleteAccessory];
                    cell.showingDeleteConfirmation should be_truthy;

                    [cell tapDeleteConfirmation];
                });

                it(@"should call the appropriate handler", ^{
                    controller.tableView.dataSource should have_received(@selector(tableView:commitEditingStyle:forRowAtIndexPath:)).with(controller.tableView, UITableViewCellEditingStyleDelete, [NSIndexPath indexPathForRow:0 inSection:0]);
                });
            });
#endif

            context(@"delete confirmation is not visible", ^{
                beforeEach(^{
                    cell.showingDeleteConfirmation should_not be_truthy;
                });

                it(@"should raise an exception", ^{
                    ^{ [cell tapDeleteConfirmation]; } should raise_exception;
                });
            });
        });
    });

    describe(@"instantiating a prototype cell", ^{
        __block SpecTableViewCell *cell;

        context(@"when explicitly specifying the view controller and table view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TableViewPrototypeCells" bundle:nil];
                cell = [SpecTableViewCell instantiatePrototypeCellFromStoryboard:storyboard viewControllerIdentifier:@"SpecTableViewPrototypeCellsViewController" tableViewKeyPath:@"tableView" cellIdentifier:@"SpecTableViewCell"];
            });

            it(@"should produce a cell of the right class", ^{
                cell should be_instance_of([SpecTableViewCell class]);
            });

            it(@"should have its subviews populated from the storyboard", ^{
                cell.subview should_not be_nil;
            });
        });

        context(@"when not providing a view controller identifier or collection view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TableViewPrototypeCells" bundle:nil];
                cell = [SpecTableViewCell instantiatePrototypeCellFromStoryboard:storyboard viewControllerIdentifier:nil tableViewKeyPath:nil cellIdentifier:@"SpecTableViewCell"];
            });

            it(@"should find a collection view in the initial view controller and produce a populated cell of the right class", ^{
                cell should be_instance_of([SpecTableViewCell class]);
                cell.subview should_not be_nil;
            });
        });
    });
});

SPEC_END
