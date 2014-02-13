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
    __block id<UICollectionViewDelegate> delegate;
    __block NSIndexPath *indexPathForCell;

    beforeEach(^{
        delegate = nice_fake_for(@protocol(UICollectionViewDelegate));
        UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        controller = [[[SpecCollectionViewController alloc] initWithCollectionViewLayout:layout] autorelease];
        controller.collectionView.delegate = delegate;
        controller.view should_not be_nil;
        [controller.view layoutIfNeeded];

        cell = controller.collectionView.visibleCells[0];
        indexPathForCell = [controller.collectionView indexPathForCell:cell];
    });

    describe(@"-tap", ^{
        subjectAction(^{ [cell tap]; });

        context(@"for a single selection collection view", ^{
            context(@"the delegate does not respond to collectionView:shouldSelectItemAtIndexPath:", ^{
                beforeEach(^{
                    delegate reject_method(@selector(collectionView:shouldSelectItemAtIndexPath:));
                });

                it(@"should result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                });
            });

            context(@"the delegate determines that the cell should be selected", ^{
                beforeEach(^{
                    delegate stub_method(@selector(collectionView:shouldSelectItemAtIndexPath:)).with(controller.collectionView, Arguments::any([NSIndexPath class])).and_return(YES);
                });

                it(@"should result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                });

                it(@"should deselect the cell if another cell is tapped", ^{
                    [controller.collectionView.visibleCells[1] tap];
                    [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                });
            });

            context(@"the delegate determines that the cell should not be selected", ^{
                beforeEach(^{
                    delegate stub_method(@selector(collectionView:shouldSelectItemAtIndexPath:)).with(controller.collectionView, Arguments::any([NSIndexPath class])).and_return(NO);
                });

                it(@"should not result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                });
            });
        });

        context(@"for a multiple selection collection view", ^{
            beforeEach(^{
                [controller.collectionView setAllowsMultipleSelection:YES];
            });

            context(@"the delegate does not respond to collectionView:shouldSelectItemAtIndexPath:", ^{
                beforeEach(^{
                    delegate reject_method(@selector(collectionView:shouldSelectItemAtIndexPath:));
                });

                it(@"should result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                });

                describe(@"tapping on the cell again", ^{
                    context(@"the delegate does not respond to collectionView:shouldDeselectItemAtIndexPath:", ^{
                        beforeEach(^{
                            delegate reject_method(@selector(collectionView:shouldDeselectItemAtIndexPath:));
                        });

                        it(@"should deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                        });
                    });

                    context(@"the delegate determines that the cell should be deselected", ^{
                        beforeEach(^{
                            delegate stub_method(@selector(collectionView:shouldDeselectItemAtIndexPath:)).with(controller.collectionView, indexPathForCell).and_return(YES);
                        });

                        it(@"should deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                        });
                    });

                    context(@"the delegate determines that the cell should not be deselected", ^{
                        beforeEach(^{
                            delegate stub_method(@selector(collectionView:shouldDeselectItemAtIndexPath:)).with(controller.collectionView, indexPathForCell).and_return(NO);
                        });

                        it(@"should not deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                        });
                    });
                });

                it(@"should not deselect the cell if another cell is tapped", ^{
                    [controller.collectionView.visibleCells[1] tap];

                    [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:0 inSection:0]);
                    [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:1 inSection:0]);
                });
            });

            context(@"the delegate determines that the cell should be selected", ^{
                beforeEach(^{
                    delegate stub_method(@selector(collectionView:shouldSelectItemAtIndexPath:)).with(controller.collectionView, Arguments::any([NSIndexPath class])).and_return(YES);
                });

                it(@"should result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                });

                describe(@"tapping on the cell again", ^{
                    context(@"the delegate does not respond to collectionView:shouldDeselectItemAtIndexPath:", ^{
                        beforeEach(^{
                            delegate reject_method(@selector(collectionView:shouldDeselectItemAtIndexPath:));
                        });

                        it(@"should deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                        });
                    });

                    context(@"the delegate determines that the cell should be deselected", ^{
                        beforeEach(^{
                            delegate stub_method(@selector(collectionView:shouldDeselectItemAtIndexPath:)).with(controller.collectionView, indexPathForCell).and_return(YES);
                        });

                        it(@"should deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                        });
                    });

                    context(@"the delegate determines that the cell should not be deselected", ^{
                        beforeEach(^{
                            delegate stub_method(@selector(collectionView:shouldDeselectItemAtIndexPath:)).with(controller.collectionView, indexPathForCell).and_return(NO);
                        });

                        it(@"should not deselect the cell", ^{
                            [cell tap];

                            [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
                        });
                    });
                });

                it(@"should not deselect the cell if another cell is tapped", ^{
                    [controller.collectionView.visibleCells[1] tap];

                    [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:0 inSection:0]);
                    [controller.collectionView indexPathsForSelectedItems] should contain([NSIndexPath indexPathForItem:1 inSection:0]);
                });
            });

            context(@"the delegate determines that the cell should not be selected", ^{
                beforeEach(^{
                    delegate stub_method(@selector(collectionView:shouldSelectItemAtIndexPath:)).with(controller.collectionView, Arguments::any([NSIndexPath class])).and_return(NO);
                });

                it(@"should not result in the cell being selected", ^{
                    [controller.collectionView indexPathsForSelectedItems] should_not contain(indexPathForCell);
                });
            });
        });
    });
});

SPEC_END
