#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSString *appDelegateName = NSClassFromString(@"XCTestCase") ? nil : @"CedarApplicationDelegate";
        return UIApplicationMain(argc, argv, nil, appDelegateName);
    }
}
