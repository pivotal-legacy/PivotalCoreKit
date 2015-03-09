#import <PivotalCoreKit/UIKit+PivotalSpecHelper.h>
#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "UIKitCore.h"

@interface UIKitTests : XCTestCase
@property (nonatomic) UIKitCore *uiKit;
@end

@implementation UIKitTests

- (void)setUp {
    [super setUp];
    self.uiKit = [[UIKitCore alloc] init];
}

- (void)testCoreViaImageViewWithImageNamed {
    XCTAssertNil(self.uiKit.imageView.image);
    [self.uiKit addImageToImageView];
    XCTAssertNotNil(self.uiKit.imageView.image);
}

- (void)testSpecHelperViaToggle {
    XCTAssertFalse(self.uiKit.aSwitch.isOn);
    [self.uiKit.aSwitch toggle];
    XCTAssertTrue(self.uiKit.aSwitch.isOn);
}

@end
