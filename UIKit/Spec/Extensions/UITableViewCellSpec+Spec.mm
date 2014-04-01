#import "SpecHelper.h"
#import "UITableViewCell+Spec.h"


@interface SpecTableViewController : UITableViewController
@property (nonatomic) BOOL shouldHightlightRows;
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
    return self.shouldHightlightRows;
}

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UITableViewCell_SpecSpec)

describe(@"UITableViewCell+Spec", ^{
    __block SpecTableViewController *controller;
    __block UITableViewCell *cell;

    beforeEach(^{
        controller = [[[SpecTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        controller.shouldHightlightRows = YES;
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
        });

        context(@"for a table with highlighting turned off", ^{
            beforeEach(^{
                controller.shouldHightlightRows = NO;
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
                [cell tapDeleteAccessory];
            });

            it(@"should expose the delete confirmation button", ^{
                cell.showingDeleteConfirmation should be_truthy;
            });
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
                spy_on(controller.tableView.dataSource);
                [controller setEditing:YES animated:NO];
            });

            context(@"delete confirmation is visible", ^{
                beforeEach(^{
                    [cell tapDeleteAccessory];
                    cell.showingDeleteConfirmation should be_truthy;

                    [cell tapDeleteConfirmation];
                });

                it(@"should call the appropriate handler", ^{
                    controller.tableView.dataSource should have_received(@selector(tableView:commitEditingStyle:forRowAtIndexPath:)).with(controller.tableView, UITableViewCellEditingStyleDelete, [NSIndexPath indexPathForRow:0 inSection:0]);
                });
            });

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
});

SPEC_END
