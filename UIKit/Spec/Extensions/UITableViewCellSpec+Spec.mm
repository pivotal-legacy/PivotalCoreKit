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
        subjectAction(^{ [cell tap]; });

        context(@"for a single selection table view", ^{
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
    });
});

SPEC_END
