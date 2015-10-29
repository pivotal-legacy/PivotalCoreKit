#import "Cedar.h"
#import "UIImage+PivotalCore.h"
#import "UIImage+Spec.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(UIImage_PivotalCoreSpec)

describe(@"UIImage_PivotalCore", ^{
    __block UIImage *originalImage;
    __block UIImage *original2xImage;
    __block NSData *imageData;

    beforeEach(^{
        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        imageData = [NSData dataWithContentsOfFile:[testBundle pathForResource:@"pivotallabs-logo" ofType:@"png"]];
        if(!imageData) {
            fail(@"Image fixture: pivotallabs-logo.png is not in the Copy Resources build phase of the test target.");
        }
        originalImage = [UIImage imageWithData:imageData scale:1.0];
        original2xImage = [UIImage imageWithData:imageData scale:2.0];
        originalImage.size should equal(CGSizeMake(223, 81));
    });

    describe(@"- aspectRatio", ^{
        it(@"should be width over height", ^{
            [NSThread sleepForTimeInterval:0.5];
            originalImage.aspectRatio should be_close_to(223.0/81);
        });
    });

    describe(@"+imageWithData:scale:", ^{
        it(@"should generate a UIImage from data, using the appropriate scale", ^{
            UIImage *image = [UIImage imageWithData:imageData scale:1.0];
            [image isEqualToByBytes:originalImage] should equal(YES);
            image.scale should equal(1.0);
            image.size should equal(CGSizeMake(223, 81));
        });

        it(@"should be readable as a @2x image", ^{
            UIImage *image = [UIImage imageWithData:imageData scale:2.0];
            image.scale should equal(2.0);
            image.size should equal(CGSizeMake(223/2.0, 81/2.0));
        });
    });

    describe(@"-resizedToSize:", ^{
        it(@"should create a new UIImage scaled to that size", ^{
            UIImage *resizedImage = [originalImage resizedToSize:CGSizeMake(100, 50)];
            resizedImage.size should equal(CGSizeMake(100, 50));
        });

        it(@"should work with @2x images", ^{
            UIImage *resized2xImage = [original2xImage resizedToSize:CGSizeMake(50, 25)];
            resized2xImage.size should equal(CGSizeMake(50, 25));
            resized2xImage.scale should equal(2);
        });
    });

    describe(@"-aspectFitResizedToSize:", ^{
        it(@"should create a new UIImage fit inside that size", ^{
            UIImage *resizedImage = [originalImage aspectFitResizedToSize:CGSizeMake(100, 50)];
            resizedImage.aspectRatio should be_close_to(originalImage.aspectRatio).within(0.1);
            (resizedImage.size.width <= 100) should equal(YES);
            (resizedImage.size.height <= 50) should equal(YES);
            (resizedImage.size.width == 100 ||
             resizedImage.size.height == 50) should equal(YES);
        });

        it(@"should also work if the new size is taller than the old size", ^{
            UIImage *resizedImage = [originalImage aspectFitResizedToSize:CGSizeMake(100, 100)];
            resizedImage.aspectRatio should be_close_to(originalImage.aspectRatio).within(0.1);
            (resizedImage.size.width <= 100) should equal(YES);
            (resizedImage.size.height <= 100) should equal(YES);
            (resizedImage.size.width == 100 ||
             resizedImage.size.height == 100) should equal(YES);
        });
    });

    describe(@"-aspectFillResizedToSizeNoCrop:", ^{
        it(@"should create a new UIImage sized to completely include that rectangle", ^{
            UIImage *resizedImage = [originalImage aspectFillResizedToSizeNoCrop:CGSizeMake(100, 50)];
            resizedImage.aspectRatio should be_close_to(originalImage.aspectRatio).within(0.1);
            (resizedImage.size.width >= 100) should equal(YES);
            (resizedImage.size.height >= 50) should equal(YES);
            (resizedImage.size.width == 100 ||
             resizedImage.size.height == 50) should equal(YES);
        });

        it(@"should also work if the new size is taller than the old size", ^{
            UIImage *resizedImage = [originalImage aspectFillResizedToSizeNoCrop:CGSizeMake(100, 100)];
            resizedImage.aspectRatio should be_close_to(originalImage.aspectRatio).within(0.1);
            (resizedImage.size.width >= 100) should equal(YES);
            (resizedImage.size.height >= 100) should equal(YES);
            (resizedImage.size.width == 100 ||
             resizedImage.size.height == 100) should equal(YES);
        });
    });

    describe(@"-croppedToRect:", ^{
        it(@"should create a new UIImage cropped to that rectangle", ^{
            UIImage *croppedImage = [originalImage croppedToRect:CGRectMake(20, 20, 20, 20)];
            croppedImage.size.width should equal(20);
            croppedImage.size.height should equal(20);
        });

        it(@"should also work with @2x images", ^{
            UIImage *croppedImage = [original2xImage croppedToRect:CGRectMake(20, 20, 20, 20)];
            croppedImage.size.width should equal(20);
            croppedImage.size.height should equal(20);
            croppedImage.scale should equal(2);
        });
    });

    describe(@"-aspectFillResized:", ^{
        it(@"should take the aspect fill without a crop and center crop it", ^{
            CGSize size = CGSizeMake(50, 50);
            UIImage *aspectFillImage = [originalImage aspectFillResizedToSize:size];
            aspectFillImage.size should equal(size);
        });

        it(@"should also work with @2x images", ^{
            CGSize size = CGSizeMake(50, 50);
            UIImage *aspectFillImage = [original2xImage aspectFillResizedToSize:size];
            aspectFillImage.size should equal(size);
            aspectFillImage.scale should equal(2);
        });
    });

    describe(@"-roundCorners:", ^{
        it(@"should clip rounded corners around the image", ^{
            UIImage *roundedImage = [originalImage imageWithRoundedCorners:5.0];
            roundedImage.size should equal(originalImage.size);
        });
    });
});

SPEC_END
