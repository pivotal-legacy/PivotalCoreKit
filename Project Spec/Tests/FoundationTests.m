#import <PivotalCoreKit/Foundation+PivotalSpecHelper.h>
#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "FoundationCore.h"

@interface FoundationTests : XCTestCase
@property (nonatomic) FoundationCore *foundation;
@end

@implementation FoundationTests

- (void)setUp {
    [super setUp];
    self.foundation = [[FoundationCore alloc] init];
}

- (void)testCoreViaTypesafeExtractionHelper {
    XCTAssertNotNil([self.foundation stringRetrievedViaTypesafeExtraction]);
}

- (void)testSpecHelperViaNSURLConnectionSpecHelper {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:nil];
    NSInteger connectionCount = [[NSURLConnection connections] count];
    XCTAssertEqual(connectionCount, 1);
}

@end
