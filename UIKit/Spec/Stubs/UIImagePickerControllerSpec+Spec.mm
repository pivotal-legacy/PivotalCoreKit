#import "SpecHelper.h"
#import "UIImagePickerController+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIImagePickerControllerSpecExtensionsSpec)

describe(@"UIImagePickerController (spec extensions)", ^{
    describe(@"+isSourceTypeAvailable:", ^{
        __block BOOL sourceAvailable;
        beforeEach(^{
            sourceAvailable = NO;
        });
        
        __block UIImagePickerControllerSourceType sourceType;
        subjectAction(^{
            sourceAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
        });
        
        describe(@"evaluating availability of UIImagePickerControllerSourceTypePhotoLibrary", ^{
            beforeEach(^{
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            });
            
            it(@"should be available by default", ^{
                sourceAvailable should be_truthy;
            });
            
            context(@"when not available", ^{
                beforeEach(^{
                    [UIImagePickerController setPhotoLibraryAvailable:NO];
                });
                
                it(@"should not be available", ^{
                    sourceAvailable should equal(NO);
                });
            });
        });
        
        describe(@"evaluating availability of UIImagePickerControllerSourceTypeCamera", ^{
            beforeEach(^{
                sourceType = UIImagePickerControllerSourceTypeCamera;
            });
            
            it(@"should be available by default", ^{
                sourceAvailable should be_truthy;
            });
        
            context(@"when not available", ^{
                beforeEach(^{
                    [UIImagePickerController setCameraAvailable:NO];
                });
                
                it(@"should not be available", ^{
                    sourceAvailable should equal(NO);
                });
            });
        });
        
        describe(@"evaluating availability of UIImagePickerControllerSourceTypeSavedPhotosAlbum", ^{
            beforeEach(^{
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            });
            
            it(@"should be available by default", ^{
                sourceAvailable should be_truthy;
            });
            
            context(@"when not available", ^{
                beforeEach(^{
                    [UIImagePickerController setSavedPhotosAlbumAvailable:NO];
                });
                
                it(@"should not be available", ^{
                    sourceAvailable should equal(NO);
                });
            });
        });
    });
});

SPEC_END
