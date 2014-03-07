#import "SpecHelper.h"
#import "UITableViewCell+Spec.h"


@interface SpecTableViewController : UITableViewController
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

@end


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UITableViewCell_SpecSpec)

describe(@"UITableViewCell+Spec", ^{
    __block SpecTableViewController *controller;
    __block UITableViewCell *cell;

    beforeEach(^{
        controller = [[[SpecTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
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

            it(@"should deselect the cell if tapped again", ^{
                [cell tap];

                [controller.tableView indexPathsForSelectedRows] should_not contain([controller.tableView indexPathForCell:cell]);
            });

            it(@"should not deselect the cell if another cell is tapped", ^{
                [controller.tableView.visibleCells[1] tap];

                [controller.tableView indexPathsForSelectedRows] should equal(@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]]);
            });
        });

        context(@"for a storyboard cell", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UITableViewCell" bundle:nil];
                controller = [storyboard instantiateInitialViewController];
                controller.view should_not be_nil;
                [controller viewWillAppear:NO];
                spy_on(controller);
            });

            context(@"with a segue attached", ^{
                beforeEach(^{
                    cell = controller.tableView.visibleCells.firstObject;
                    [cell tap];
                });

                it(@"should perform the segue on the table view controller", ^{
                    controller should have_received(@selector(performSegueWithIdentifier:sender:)).with(@"PCKSegueIdentifier", cell);
                });
            });

            context(@"without a segue attached", ^{
                beforeEach(^{
                    cell = controller.tableView.visibleCells[1];
                    [cell tap];
                });

                it(@"should not perform any segues on the table view controller", ^{
                    controller should_not have_received(@selector(performSegueWithIdentifier:sender:));
                });
            });

            context(@"with an unidentified segue attached", ^{
                beforeEach(^{
                    cell = controller.tableView.visibleCells[2];
                });

                it(@"should raise an exception", ^{
                    ^{ [cell tap]; } should raise_exception.with_reason(@"Cell with a segue must have a segue identifier in order to be tapped");
                });
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
