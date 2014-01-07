#import "SpecHelper.h"
#import "UIImageView+PivotalCore.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIImageView_PivotalCoreSpec)

describe(@"UIImageView_PivotalCore", ^{
    __block UIImageView *imageView;
    __block UIImageView *returnedImageView;

    beforeEach(^{
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h"]] autorelease];
        returnedImageView = [UIImageView imageViewWithImageNamed:@"Default-568h"];
    });

    it(@"should return an image view with the correct image", ^{
        returnedImageView.image should equal(imageView.image);
    });
});

SPEC_END
