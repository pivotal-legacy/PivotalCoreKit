#import "Cedar.h"
#import "UICollectionReusableView+Spec.h"
#import "PrototypeCellObjects.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UICollectionReusableView_SpecSpec)

describe(@"UICollectionReusableView_Spec", ^{

    describe(@"instantiating a prototype reusable view", ^{
        __block SpecCollectionReusableView *view;

        context(@"when explicitly specifying the view controller and collection view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CollectionViewPrototypeCells" bundle:nil];
                view = [SpecCollectionReusableView instantiatePrototypeReusableViewFromStoryboard:storyboard viewControllerIdentifier:@"SpecCollectionViewPrototypeCellsViewController" collectionViewKeyPath:@"collectionView" viewIdentifier:@"SpecCollectionReusableView"];
            });

            it(@"should produce a populated view of the right class", ^{
                view should be_instance_of([SpecCollectionReusableView class]);
                view.subview should_not be_nil;
            });
        });

        context(@"when not providing a view controller identifier or collection view key path", ^{
            beforeEach(^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CollectionViewPrototypeCells" bundle:nil];
                view = [SpecCollectionReusableView instantiatePrototypeReusableViewFromStoryboard:storyboard viewControllerIdentifier:nil collectionViewKeyPath:nil viewIdentifier:@"SpecCollectionReusableView"];
            });

            it(@"should find a collection view in the initial view controller and produce a populated view of the right class", ^{
                view should be_instance_of([SpecCollectionReusableView class]);
                view.subview should_not be_nil;
            });
        });
    });
});

SPEC_END
