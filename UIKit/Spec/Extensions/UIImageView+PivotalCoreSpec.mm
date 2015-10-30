#import "Cedar.h"
#import "UIImageView+PivotalCore.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIImageView_PivotalCoreSpec)

describe(@"UIImageView_PivotalCore", ^{
    __block UIImageView *imageView;
    __block UIImageView *returnedImageView;

    beforeEach(^{
        UIImage *image = [UIImage imageNamed:@"pivotallabs-logo"];
        if(!image) {
            fail(@"Image matching name: pivotallabs-logo is not found in the application bundle.");
        }
        imageView = [[UIImageView alloc] initWithImage:image];
        returnedImageView = [UIImageView imageViewWithImageNamed:@"pivotallabs-logo"];
    });

    it(@"should return an image view with the correct image", ^{
        returnedImageView.image should equal(imageView.image);
    });
});

SPEC_END
