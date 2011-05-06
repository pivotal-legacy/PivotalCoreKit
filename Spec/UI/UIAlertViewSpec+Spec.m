#import "SpecHelper.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "OCMock.h"

#import "UIAlertView+Spec.h"

SPEC_BEGIN(UIAlertViewSpecExtensionsSpec)

describe(@"UIAlertView (spec extensions)", ^{
	__block UIAlertView *alertView;
	__block id mockDelegate;
	
	beforeEach(^{
		mockDelegate = [OCMockObject niceMockForProtocol:@protocol(UIAlertViewDelegate)];
		alertView = [[[UIAlertView alloc] initWithTitle:@"Title"
												message:@"Message"
											   delegate:mockDelegate
									  cancelButtonTitle:@"Cancel"
									  otherButtonTitles:@"OK", nil] autorelease];
	});
	
	afterEach(^{
		[UIAlertView reset];
	});
	
	describe(@"Getting the current alert view with currentAlertView", ^{
		describe(@"when the alert view is not shown", ^{
			beforeEach(^{
				assertThatBool(alertView.isVisible, equalToBool(NO));
			});
			
			it(@"should return nil", ^{
				assertThat([UIAlertView currentAlertView], nilValue());
			});
		});
		
		describe(@"when the alert view is shown", ^{
			beforeEach(^{
				alertView.show;
			});
			
			it(@"should return the alert view", ^{
				assertThat([UIAlertView currentAlertView], equalTo(alertView));
			});
			
			describe(@"when the alertView is subsequently dismissed", ^{
				beforeEach(^{
					[alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex
												   animated:NO];
				});
				
				it(@"should return nil", ^{
					assertThat([UIAlertView currentAlertView], nilValue());
				});
			});
			
			describe(@"when the UIAlertView class is subsequently reset", ^{
				beforeEach(^{
					[UIAlertView reset];
				});
				
				it(@"should return nil", ^{
					assertThat([UIAlertView currentAlertView], nilValue());
				});
			});
		});
	});
	
	describe(@"checking visibility with isVisible", ^{
		describe(@"when the alert view is not shown", ^{
			it(@"should return NO", ^{
				assertThatBool(alertView.isVisible, equalToBool(NO));
			});
		});
		
		describe(@"when the alert view is shown", ^{
			beforeEach(^{
				alertView.show;
			});
			
			it(@"should return YES", ^{
				assertThatBool(alertView.isVisible, equalToBool(YES));
			});
			
			describe(@"when the UIAlertView class is subsequently dismissed", ^{
				beforeEach(^{
					[alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex
												   animated:NO];
				});
				
				it(@"should return NO", ^{
					assertThatBool(alertView.isVisible, equalToBool(NO));
				});
			});
		});		
	});
	
	describe(@"forwarding callbacks", ^{
		describe(@"when the alertView is dismissed with the cancel button", ^{
			it(@"should notify the delegate passing in the appropriate button", ^{
				[[mockDelegate expect] alertView:alertView didDismissWithButtonIndex:alertView.cancelButtonIndex];
				
				[alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex
											   animated:NO];
				
				[mockDelegate verify];
			});
		});
		
		describe(@"when the alertView is dismissed with the other button", ^{
			it(@"should notify the delegate passing in the appropriate button", ^{
				[[mockDelegate expect] alertView:alertView didDismissWithButtonIndex:alertView.firstOtherButtonIndex];
				
				[alertView dismissWithClickedButtonIndex:alertView.firstOtherButtonIndex
											   animated:NO];
				
				[mockDelegate verify];
			});
		});
	});
	
});

SPEC_END
