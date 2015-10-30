#import "Cedar.h"
#import "WKImage.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKImageSpec)

describe(@"WKImage", ^{
    NSString *imageName = @"corgi.jpeg";
    __block UIImage *uiImage;

    beforeEach(^{
        uiImage = [UIImage imageNamed:imageName];
        uiImage should_not be_nil;
    });

    sharedExamplesFor(@"a WKImage value object", ^(NSDictionary *sharedContext) {
        __block WKImage *image;
        __block NSString *keyPath;
        __block id inputData;

        beforeEach(^{
            image = sharedContext[@"image"];
            keyPath = sharedContext[@"keyPath"];
            inputData = sharedContext[@"inputData"];
        });

        it(@"should be equal to its copy", ^{
            [image copy] should equal(image);
        });

        it(@"should have the same hash as its copy", ^{
            [[image copy] hash] should equal([image hash]);
        });

        it(@"should be archivable", ^{
            WKImage *reconstructedImage = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:image]];
            reconstructedImage should equal(image);
        });

        it(@"should expose the input data on the correct key path", ^{
            [image valueForKeyPath:keyPath] should equal(inputData);
        });
    });

    describe(@"created with a UIImage", ^{
        itShouldBehaveLike(@"a WKImage value object", ^(NSMutableDictionary *context) {
            context[@"image"] = [WKImage imageWithImage:uiImage];
            context[@"keyPath"] = NSStringFromSelector(@selector(image));
            context[@"inputData"] = uiImage;
        });
    });

    describe(@"created with NSData", ^{
        itShouldBehaveLike(@"a WKImage value object", ^(NSMutableDictionary *context) {
            NSData *data = UIImagePNGRepresentation(uiImage);
            context[@"image"] = [WKImage imageWithImageData:data];
            context[@"keyPath"] = NSStringFromSelector(@selector(imageData));
            context[@"inputData"] = data;
        });
    });

    describe(@"created with an image name", ^{
        itShouldBehaveLike(@"a WKImage value object", ^(NSMutableDictionary *context) {
            context[@"image"] = [WKImage imageWithImageName:imageName];
            context[@"keyPath"] = NSStringFromSelector(@selector(imageName));
            context[@"inputData"] = imageName;
        });
    });
});

SPEC_END
