#import "Cedar.h"
#import "CorgisController.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "WKInterfaceController.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKInterfaceControllerSpec)

describe(@"WKInterfaceController", ^{
    __block InterfaceController *subject;

    beforeEach(^{
        InterfaceControllerLoader *loader = [[InterfaceControllerLoader alloc] init];
        subject = [loader interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc" context:@""];

    });

    describe(@"pushing another controller onto itself", ^{
        beforeEach(^{
            [subject pushControllerWithName:@"MyFirstCorgiController" context:nil];
        });

        it(@"should have a new child controller with the correct interface controller class", ^{
            subject.childController should be_instance_of([CorgisController class]);
        });
    });
});

SPEC_END
