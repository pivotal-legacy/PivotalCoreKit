#import "Cedar.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(InterfaceControllerLoaderSpec)

describe(@"InterfaceControllerLoader", ^{

    __block InterfaceControllerLoader *subject;
    beforeEach(^{
        subject = [[InterfaceControllerLoader alloc] init];
    });

    describe(@"providing an instance of a WKInterfaceController subclass that lives in a storyboard's plist, inside the test bundle", ^{
        
        context(@"when there is no storyboard matching the name", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [subject interfaceControllerWithStoryboardName:@"NonExistantName" objectID:@"DoesntMatter" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No storyboard named 'NonExistantName' exists in the test target.  Did you forget to add it?");
                
            });
        });
        
        context(@"when there is no interface controller matching the object id", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [subject interfaceControllerWithStoryboardName:@"Interface" objectID:@"NonExistantController" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No interface controller named 'NonExistantController' exists in the storyboard 'Interface'.  Please check the storyboard and try again.");
            });
        });
        
        context(@"when there is an interface controller matching the object id", ^{
            __block InterfaceController *controller;

            beforeEach(^{
                controller = [subject interfaceControllerWithStoryboardName:@"Interface" objectID:@"AgC-eL-Hgc" context:nil];
            });

            it(@"should return the correct type of interface controller", ^{
                controller should be_instance_of([InterfaceController class]);
            });

            describe(@"the interface controller's properties", ^{
                it(@"should have a title label (when one was specified in the storyboard)", ^{
                    controller.titleLabel.text should equal(@"Some text");
                });

                it(@"should have a image (when one was specified in the storyboard)", ^{
                    controller.image.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
                });

                it(@"should have a separator (when one was specified in the storyboard)", ^{
                    controller.separator.color should equal([UIColor darkGrayColor]);
                });
            });
        });
    });
});

SPEC_END
