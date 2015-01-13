#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKUserNotificationInterfaceControllerSpec)

describe(@"WKUserNotificationInterfaceController", ^{
    __block WKUserNotificationInterfaceController *subject;

    beforeEach(^{
        subject = [[WKUserNotificationInterfaceController alloc] init];
    });

    describe(@"receiving notifications", ^{


        describe(@"remote notifications", ^{
            __block BOOL completionBlockCalled;

            beforeEach(^{
                completionBlockCalled = NO;
                [subject didReceiveRemoteNotification:@{@"a": @1} withCompletion:^(WKUserNotificationInterfaceType interface) {
                    completionBlockCalled = YES;
                }];
            });

            it(@"should record the invocation when it receives the did receive remote notification message", ^{
                subject should have_received(@selector(didReceiveRemoteNotification:withCompletion:)).with(@{@"a": @1}, Arguments::anything);
            });

            it(@"should store the last completion block on a public property", ^{
                subject.lastCompletionBlock(WKUserNotificationInterfaceTypeDefault);
                completionBlockCalled should be_truthy;
            });

        });

        describe(@"local notifications", ^{
            __block BOOL completionBlockCalled;
            beforeEach(^{
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.userInfo = @{@"a": @1};
                completionBlockCalled = NO;
                [subject didReceiveLocalNotification:notification withCompletion:^(WKUserNotificationInterfaceType interface) {
                    completionBlockCalled = YES;
                }];
            });

            it(@"should record the invocation when it receives the did receive remote notification message", ^{
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.userInfo = @{@"a": @1};
                subject should have_received(@selector(didReceiveLocalNotification:withCompletion:)).with(notification, Arguments::anything);
            });

            it(@"should store the last completion block on a public property", ^{
                subject.lastCompletionBlock(WKUserNotificationInterfaceTypeDefault);
                completionBlockCalled should be_truthy;
            });
            
        });

    });
});

SPEC_END
