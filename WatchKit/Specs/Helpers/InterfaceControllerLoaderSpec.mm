#import "Cedar.h"
#import "InterfaceController.h"
#import "InterfaceControllerLoader.h"
#import "WKInterfaceButton+Spec.h"
#import "WKInterfaceDate+Spec.h"
#import "WKInterfaceGroup+Spec.h"
#import "WKInterfaceImage+Spec.h"
#import "WKInterfaceLabel+Spec.h"
#import "WKInterfaceSeparator+Spec.h"
#import "WKInterfaceSlider+Spec.h"
#import "WKInterfaceSwitch+Spec.h"
#import "WKInterfaceTimer+Spec.h"


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
                ^{ [subject interfaceControllerWithStoryboardName:@"NonExistantName" identifier:@"DoesntMatter"]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No storyboard named 'NonExistantName' exists in the test target.  Did you forget to add it?");
                
            });
        });
        
        context(@"when there is no interface controller instance in an existing storyboard that matches the object id", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"NonExistantController"]; } should raise_exception
                    .with_name(NSInvalidArgumentException)
                    .with_reason(@"No interface controller named 'NonExistantController' exists in the storyboard 'Interface'.  Please check the storyboard and try again.");
            });
        });

        context(@"when there is an interface controller instance in an existing storyboard but its class doesn't exist in the current target", ^{
            it(@"should raise an exception with a helpful message", ^{
                ^{ [subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"myNonExistantController"]; } should raise_exception
                .with_name(NSInvalidArgumentException)
                .with_reason(@"No class named 'NonExistantController' exists in the current target.  Did you forget to add it to the test target?");
            });
        });

        context(@"when there is an interface controller matching the object id", ^{
            __block InterfaceController *controller;

            beforeEach(^{
                controller = [subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc"];
            });

            it(@"should return the correct type of interface controller", ^{
                controller should be_instance_of([InterfaceController class]);
            });

            describe(@"the interface controller's properties", ^{
                describe(@"the title label", ^{
                    __block WKInterfaceLabel *titleLabel;
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
                    __block WKInterfaceButton *button;
                    beforeEach(^{
                        button = controller.actionButton;
                    });

                    it(@"should have the correct text", ^{
                        button.title should equal(@"actionButton");
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
                    __block WKInterfaceDate *date;
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
                    __block WKInterfaceSwitch *theSwitch;
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

                describe(@"the slider", ^{

                    context(@"when enabled in the storyboard", ^{
                        __block WKInterfaceSlider *enabledSlider;

                        beforeEach(^{
                            enabledSlider = controller.enabledSlider;
                        });

                        it(@"should have the correct default enabled property", ^{
                            enabledSlider.enabled should be_truthy;
                        });

                        it(@"should have the correct value", ^{
                            enabledSlider.value should be_close_to(2.7).within(FLT_EPSILON);
                        });

                        it(@"should have the number of steps", ^{
                            enabledSlider.numberOfSteps should equal(8);
                        });

                        it(@"should have the correct minimum", ^{
                            enabledSlider.minimum should equal(2);
                        });

                        it(@"should have the correct maximum", ^{
                            enabledSlider.maximum should equal(10);
                        });

                        it(@"should have the correct minimum image", ^{
                            enabledSlider.minimumImage should equal([UIImage imageNamed:@"minus"]);
                        });

                        it(@"should have the correct maximum image", ^{
                            enabledSlider.maximumImage should equal([UIImage imageNamed:@"plus"]);
                        });

                        it(@"should have the correct continuous value", ^{
                            enabledSlider.continuous should be_truthy;
                        });
                    });

                    context(@"when disabled in the storyboard", ^{
                        __block WKInterfaceSlider *disabledSlider;

                        beforeEach(^{
                            disabledSlider = controller.disabledSlider;
                        });

                        it(@"should have the correct disabled property", ^{
                            disabledSlider.enabled should_not be_truthy;
                        });
                    });
                });

                describe(@"the group", ^{
                    context(@"single group", ^{
                        __block WKInterfaceGroup *singleGroup;

                        beforeEach(^{
                            singleGroup = controller.singleGroup;
                        });

                        it(@"should have all of the containing interface objects specified in the storyboard", ^{
                            singleGroup.items.count should equal(2);

                            WKInterfaceImage *firstImage = singleGroup.items[0];
                            WKInterfaceImage *secondImage = singleGroup.items[1];
                            firstImage.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
                            secondImage.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
                        });
                    });

                    context(@"nested group", ^{
                        __block WKInterfaceGroup *nestedGroup;
                        beforeEach(^{
                            nestedGroup = controller.nestedGroup;
                        });

                        it(@"should correctly deserialize nested groups", ^{
                            WKInterfaceGroup *innerGroup = nestedGroup.items.firstObject;
                            WKInterfaceImage *image = innerGroup.items.firstObject;
                            image.image should equal([UIImage imageNamed:@"corgi.jpeg"]);
                        });
                    });
                });

                describe(@"the timer", ^{
                    __block WKInterfaceTimer *timer;
                    beforeEach(^{
                        timer = controller.timer;
                    });

                    it(@"should correctly set the format string with a bitmask", ^{
                        TimerFormatOptions options;
                        options = TimerFormatOptionsYears | TimerFormatOptionsMonths | TimerFormatOptionsWeeks | TimerFormatOptionsDays | TimerFormatOptionsHours | TimerFormatOptionsMinutes | TimerFormatOptionsSeconds;
                        timer.units should equal(options);
                    });

                    it(@"should have the correct enabled property", ^{
                        timer.enabled should be_truthy;
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

        context(@"when there is an interface objects associated with the controller that does not have a corresponding outlet", ^{

            it(@"should not throw a runtime exception, because it doesn't throw one in production", ^{
                ^{[subject interfaceControllerWithStoryboardName:@"Interface" identifier:@"AgC-eL-Hgc"]; } should_not raise_exception;
            });
        });
    });
});

SPEC_END
