#import <PivotalCoreKit/CoreLocation+PivotalSpecHelper.h>
#import <CoreLocation/CoreLocation.h>
#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

@interface CoreLocationTests : XCTestCase

@end

@implementation CoreLocationTests

- (void)testSpecHelperViaGeocoder {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.7403 longitude:-73.9941];

    XCTAssertFalse(geocoder.isGeocoding);
    [geocoder reverseGeocodeLocation:location completionHandler:nil];
    XCTAssertTrue(geocoder.isGeocoding);
}

@end
