#import "SpecHelper.h"
#import "UICollectionViewCell+Spec.h"
#import "PrototypeCellObjects.h"

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
        delegate = fake_for(@protocol(UICollectionViewDelegate));
        delegate stub_method(@selector(collectionView:shouldSelectItemAtIndexPath:)).and_return(YES);
        delegate stub_method(@selector(collectionView:didSelectItemAtIndexPath:));

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

        it(@"should trigger selection as expected", ^{
            [controller.collectionView indexPathsForSelectedItems] should contain(indexPathForCell);
        });

        it(@"should call implemented delegate methods", ^{
            delegate should have_received(@selector(collectionView:shouldSelectItemAtIndexPath:));
            delegate should have_received(@selector(collectionView:didSelectItemAtIndexPath:)).with(controller.collectionView, indexPathForCell);
        });
    });

    describe(@"instantiating a prototype cell", ^{
        __block SpecCollectionViewCell *cell;

        context(@"when explicitly specifying the view controller and collection view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CollectionViewPrototypeCells" bundle:nil];
                cell = [SpecCollectionViewCell instantiatePrototypeCellFromStoryboard:storyboard viewControllerIdentifier:@"SpecCollectionViewPrototypeCellsViewController" collectionViewKeyPath:@"collectionView" cellIdentifier:@"SpecCollectionViewCell"];
            });

            it(@"should produce a cell of the right class", ^{
                cell should be_instance_of([SpecCollectionViewCell class]);
            });

            it(@"should have its subviews populated from the storyboard", ^{
                cell.subview should_not be_nil;
            });
        });

        context(@"when not providing a view controller identifier or collection view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CollectionViewPrototypeCells" bundle:nil];
                cell = [SpecCollectionViewCell instantiatePrototypeCellFromStoryboard:storyboard viewControllerIdentifier:nil collectionViewKeyPath:nil cellIdentifier:@"SpecCollectionViewCell"];
            });

            it(@"should find a collection view in the initial view controller and produce a populated cell of the right class", ^{
                cell should be_instance_of([SpecCollectionViewCell class]);
                cell.subview should_not be_nil;
            });
        });
    });
});

SPEC_END
