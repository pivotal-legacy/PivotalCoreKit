#import "Cedar.h"
#import "InterfaceControllerLoader.h"
#import "CorgiTableController.h"
#import "WKInterfaceTable+Spec.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceTableSpec)

describe(@"WKInterfaceTable", ^{
    __block WKInterfaceTable *subject;
    __block CorgiTableController *controller;
    __block InterfaceControllerLoader *loader;

    beforeEach(^{
        loader = [[InterfaceControllerLoader alloc] init];
        controller = [loader interfaceControllerWithStoryboardName:@"Interface" identifier:@"MyCorgiTableController"];
        subject = controller.table;
    });

    describe(@"setters", ^{
        it(@"should be able to set row types", ^{
            [subject setRowTypes:@[@"A", @"B", @"C"]];
            subject should have_received(@selector(setRowTypes:)).with(@[@"A", @"B", @"C"]);
        });

        it(@"should be able to set the number of rows and specify their types", ^{
            [subject setNumberOfRows:3 withRowType:@"MySpecialRowType"];
            subject should have_received(@selector(setNumberOfRows:withRowType:)).with(3, @"MySpecialRowType");
        });

        it(@"should be able to insert rows with types", ^{
            NSIndexSet *expectedIndexSet = [NSIndexSet indexSetWithIndex:1];
            [subject insertRowsAtIndexes:expectedIndexSet withRowType:@"MySpecialRowType"];
            subject should have_received(@selector(insertRowsAtIndexes:withRowType:)).with(expectedIndexSet, @"MySpecialRowType");
        });

        it(@"should be able to remove rows at specified indices", ^{
            NSIndexSet *expectedIndexSet = [NSIndexSet indexSetWithIndex:1];
            [subject removeRowsAtIndexes:expectedIndexSet];
            subject should have_received(@selector(removeRowsAtIndexes:)).with(expectedIndexSet);
        });

        it(@"should be able to scroll to a row at a specified indices", ^{
            [subject scrollToRowAtIndex:1];
            subject should have_received(@selector(scrollToRowAtIndex:)).with(1);
        });
    });

    describe(@"row configuration from storyboard", ^{

        it(@"should be able to read the default number of rows set in the storyboard", ^{
            subject.numberOfRows should equal(2);
        });
    });
});

SPEC_END
