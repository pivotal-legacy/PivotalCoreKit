#import "SpecHelper.h"
#import "UICollectionViewCell+Spec.h"

@interface SpecCollectionViewController : UICollectionViewController
@end

@implementation SpecCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UICollectionViewCell_SpecSpec)

describe(@"UICollectionViewCell+Spec", ^{
    __block SpecCollectionViewController *controller;
    __block UICollectionViewCell *cell;

    beforeEach(^{
        UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        controller = [[[SpecCollectionViewController alloc] initWithCollectionViewLayout:layout] autorelease];
        controller.view should_not be_nil;
        [controller.view layoutIfNeeded];

        cell = controller.collectionView.visibleCells[0];
    });

    describe(@"-tap", ^{
        subjectAction(^{ [cell tap]; });

        context(@"for a single selection collection view", ^{
            it(@"should result in the cell being selected", ^{
                [controller.collectionView indexPathsForSelectedItems][0] should equal([controller.collectionView indexPathForCell:cell]);
            });

            it(@"should deselect the cell if another cell is tapped", ^{
                [controller.collectionView.visibleCells[1] tap];

                [controller.collectionView indexPathsForSelectedItems][0] should_not equal([controller.collectionView indexPathForCell:cell]);
            });
        });

        context(@"for a multiple selection collection view", ^{
            beforeEach(^{
                [controller.collectionView setAllowsMultipleSelection:YES];
            });

            it(@"should results in the cell being selected", ^{
                [controller.collectionView indexPathsForSelectedItems][0] should equal ([controller.collectionView indexPathForCell:cell]);
            });

            it(@"should deselect the cell if tapped again", ^{
                [cell tap];

                [controller.collectionView indexPathsForSelectedItems] should_not contain([controller.collectionView indexPathForCell:cell]);
            });

            it(@"should not deselect the cell if another cell is tapped", ^{
                [controller.collectionView.visibleCells[1] tap];

                [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:0 inSection:0]);
                [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:1 inSection:0]);
            });
        });
    });
});

SPEC_END
