#import "Cedar.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "TestableWKInterfaceButton.h"
#import "TestableWKInterfaceDate.h"
#import "TestableWKInterfaceSwitch.h"

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
                ^{ [subject interfaceControllerWithStoryboardName:@"NonExistantName" identifier:@"DoesntMatter" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No storyboard named 'NonExistantName' exists in the test target.  Did you forget to add it?");
                
            });
        });
        
        context(@"when there is no interface controller matching the object id", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"NonExistantController" context:nil]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No interface controller named 'NonExistantController' exists in the storyboard 'Interface'.  Please check the storyboard and try again.");
            });
        });
        
        context(@"when there is an interface controller matching the object id", ^{
            __block InterfaceController *controller;

            beforeEach(^{
                controller = [subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc" context:nil];
            });

            it(@"should return the correct type of interface controller", ^{
                controller should be_instance_of([InterfaceController class]);
            });

            describe(@"the interface controller's properties", ^{
                describe(@"the title label", ^{
                    __block id <TestableWKInterfaceLabel> titleLabel;
                    beforeEach(^{
                        titleLabel = controller.titleLabel;
                    });

                    it(@"should have the correct text", ^{
                        titleLabel.text should equal(@"Some text");
                    });

                    it(@"should have the correct text color", ^{
                        titleLabel.textColor should equal([UIColor colorWithRed:255.0f / 255.0f
                                                                          green:125.0f / 255.0f
                                                                           blue:55.0f / 255.0f
                                                                          alpha:1.0]);
                    });
                });

                describe(@"the button", ^{
                    __block id <TestableWKInterfaceButton> button;
                    beforeEach(^{
                        button = controller.button;
                    });

                    it(@"should have the correct text", ^{
                        button.title should equal(@"Button");
                    });

                    it(@"should have the correct text color", ^{
                        button.color should equal([UIColor lightGrayColor]);
                    });

                    it(@"should have the correct default enabled property", ^{
                        button.enabled should be_truthy;
                    });

                    it(@"should allow the enabled property to be toggled programatically", ^{
                        [controller didDeactivate];
                        button.enabled should_not be_truthy;
                    });
                });

                describe(@"the date", ^{
                    __block id <TestableWKInterfaceDate> date;
                    beforeEach(^{
                        date = controller.date;
                    });

                    it(@"should display date in the correct format", ^{
                        date.format should equal(@"yy-M-d");
                    });

                    it(@"should display the correct color", ^{
                        date.textColor should equal([UIColor lightGrayColor]);
                    });
                });

                describe(@"the switch", ^{
                    __block id <TestableWKInterfaceSwitch> theSwitch;
                    beforeEach(^{
                        theSwitch = controller.theSwitch;
                    });

                    it(@"should have the correct default enabled property", ^{
                        theSwitch.enabled should be_truthy;
                    });

                    it(@"should allow the enabled property to be toggled programatically", ^{
                        [controller didDeactivate];
                        theSwitch.enabled should_not be_truthy;
                    });

                    it(@"should have the correct default on property", ^{
                        theSwitch.on should be_truthy;
                    });

                    it(@"should allow the on property to be toggled programatically", ^{
                        [controller didDeactivate];
                        theSwitch.on should_not be_truthy;
                    });
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
