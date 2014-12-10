#import "Cedar.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(InterfaceControllerLoaderSpec)

describe(@"InterfaceControllerLoader", ^{


    describe(@"providing an instance of a WKInterfaceController subclass that lives in a storyboard's plist, inside the test bundle", ^{
        
        context(@"when there is no storyboard matching the name", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [InterfaceControllerLoader interfaceControllerWithStoryboardName:@"NonExistantName" objectID:@"DoesntMatter" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No storyboard named 'NonExistantName' exists in the test target.  Did you forget to add it?");
                
            });
        });
        
        context(@"when there is no interface controller matching the object id", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [InterfaceControllerLoader interfaceControllerWithStoryboardName:@"Interface" objectID:@"NonExistantController" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No interface controller named 'NonExistantController' exists in the storyboard 'Interface'.  Please check the storyboard and try again.");
            });
        });
        
        context(@"when there is an interface controller matching the object id", ^{
            it(@"should return the correct type of interface controller", ^{
                id interfaceController = [InterfaceControllerLoader interfaceControllerWithStoryboardName:@"Interface" objectID:@"AgC-eL-Hgc" context:nil];
                interfaceController should be_instance_of([InterfaceController class]);
            });
        });
    });
});

SPEC_END
