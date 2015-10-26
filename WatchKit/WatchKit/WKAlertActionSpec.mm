#import "Cedar.h"
#import "WKAlertAction.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WKAlertActionSpec)

describe(@"WKAlertAction", ^{
    describe(@"equality", ^{
        it(@"should treat two alert actions with the same title and style as equal", ^{
            WKAlertAction *action1 = [WKAlertAction actionWithTitle:@"title" style:WKAlertActionStyleCancel handler:^{}];
            WKAlertAction *action2 = [WKAlertAction actionWithTitle:@"title" style:WKAlertActionStyleCancel handler:^{}];

            action1 should equal(action2);
            [action1 hash] should equal([action2 hash]);
        });
    });
});

SPEC_END
