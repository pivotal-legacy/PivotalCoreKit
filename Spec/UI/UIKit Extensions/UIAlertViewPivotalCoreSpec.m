#import "SpecHelper.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "OCMock.h"

#import "UIAlertView+PivotalCore.h"

SPEC_BEGIN(UIAlertViewPivotalCoreExtensionsSpec)

describe(@"UIAlertView (pivotal core extensions)", ^{
	__block UIAlertView *alertView;
	__block NSObject *context;
	__block id mockDelegate;
	
	beforeEach(^{
		context = [[[NSObject alloc] init] autorelease];
		mockDelegate = [OCMockObject niceMockForProtocol:@protocol(UIAlertViewDelegate)];

		alertView = [[[UIAlertView alloc] initWithTitle:@"Title"
												message:@"Message"
											   delegate:mockDelegate
												context:context
									  cancelButtonTitle:@"Cancel"
									  otherButtonTitle:@"OK"] autorelease];
	});
		
	describe(@"Retrieving the context object", ^{
		it(@"should return the context object", ^{
			assertThat(alertView.context, equalTo(context));
		});
	});
	
	describe(@"Correctly handling passed in button titles", ^{ //this is mildly complicated by the fact that UIAlertView's default initializer takes a variadic argument
		describe(@"When an otherButtonTitle is provided ", ^{
			it(@"should have two buttons", ^{
				assertThatInt(alertView.numberOfButtons, equalToInt(2));
			});
			
			it(@"should correctly identify the other button's label", ^{
				assertThat([alertView buttonTitleAtIndex:alertView.firstOtherButtonIndex], equalTo(@"OK"));
			});
		});
		
		describe(@"When an otherButtonTitle is not provided ", ^{
			beforeEach(^{
				alertView = [[[UIAlertView alloc] initWithTitle:@"Title"
														message:@"Message"
													   delegate:mockDelegate
														context:context
											  cancelButtonTitle:@"Cancel"
											   otherButtonTitle:nil] autorelease];
			});
			
			it(@"should have one button", ^{
				assertThatInt(alertView.numberOfButtons, equalToInt(1));
			});
		});		
	});
});

SPEC_END
