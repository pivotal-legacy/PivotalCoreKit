#import "CDRSpecHelper.h"
#import "UIImageView+PivotalCore.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIImageView_PivotalCoreSpec)

describe(@"UIImageView_PivotalCore", ^{
    __block UIImageView *imageView;
    __block UIImageView *returnedImageView;

    beforeEach(^{
        UIImage *image = [UIImage imageNamed:@"Default-568h"];
        if(!image) {
            fail(@"Image matching name: Default-568h is not found in the application bundle.");
        }
        imageView = [[UIImageView alloc] initWithImage:image];
        returnedImageView = [UIImageView imageViewWithImageNamed:@"Default-568h"];
    });

    it(@"should return an image view with the correct image", ^{
        returnedImageView.image should equal(imageView.image);
    });
});

SPEC_END
