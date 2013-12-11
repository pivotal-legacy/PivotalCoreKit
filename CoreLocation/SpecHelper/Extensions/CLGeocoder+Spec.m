#import "CLGeocoder+Spec.h"
#import "objc/runtime.h"

@interface CLGeocoderAttributes : NSObject
@property (nonatomic, assign) BOOL geocoding;
@property (nonatomic, retain) NSString *addressString;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, copy) CLGeocodeCompletionHandler completionHandler;
@end

@implementation CLGeocoderAttributes
@synthesize geocoding = geocoding_
, completionHandler = completionHandler_
, addressString = addressString_
, location = location_;

- (void)dealloc {
    self.completionHandler = nil;
    self.addressString = nil;
    [super dealloc];
}
@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface CLGeocoder (SpecPrivate)
- (CLGeocoderAttributes *)attributes;
@end

static char CLGEOCODER_ATTRIBUTES_KEY;

@implementation CLGeocoder (Spec)

- (id)init {
    if (self = [super init]) {
        CLGeocoderAttributes *attributes = [[[CLGeocoderAttributes alloc] init] autorelease];
        objc_setAssociatedObject(self, &CLGEOCODER_ATTRIBUTES_KEY, attributes, OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    self.attributes.geocoding = YES;
    self.attributes.location = location;
    self.attributes.completionHandler = completionHandler;
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    self.attributes.geocoding = YES;
    self.attributes.addressString = addressString;
    self.attributes.completionHandler = completionHandler;
}

- (void)cancelGeocode {
    if (self.attributes.completionHandler) {
        self.attributes.completionHandler(nil, [NSError errorWithDomain:@"Canceled" code:-1 userInfo:nil]);
    }
    self.attributes.addressString = nil;
    self.attributes.completionHandler = nil;
    self.attributes.geocoding = NO;
}

- (BOOL)isGeocoding {
    return self.attributes.geocoding;
}

- (NSString *)addressString {
    return self.attributes.addressString;
}

- (CLLocation *)location {
    return self.attributes.location;
}

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks {
    if (!self.geocoding) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempt to complete geocode when not geocoding" userInfo:nil] raise];
    }

    if (self.attributes.completionHandler) {
        self.attributes.completionHandler(placemarks, nil);
    }
    self.attributes.addressString = nil;
    self.attributes.completionHandler = nil;
    self.attributes.geocoding = NO;
}

- (void)completeReverseGeocodeWithPlacemarks:(NSArray *)placemarks {
    if (!self.geocoding) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempt to complete geocode when not geocoding" userInfo:nil] raise];
    }

    if (self.attributes.completionHandler) {
        self.attributes.completionHandler(placemarks, nil);
    }
    self.attributes.location = nil;
    self.attributes.completionHandler = nil;
    self.attributes.geocoding = NO;
}

- (void)completeGeocodeWithError:(NSError *)error {
    if (!self.geocoding) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempt to complete geocode when not geocoding" userInfo:nil] raise];
    }

    if (self.attributes.completionHandler) {
        self.attributes.completionHandler(nil, error);
    }
    self.attributes.addressString = nil;
    self.attributes.completionHandler = nil;
    self.attributes.geocoding = NO;
}

#pragma mark - Private interface

- (CLGeocoderAttributes *)attributes {
    return objc_getAssociatedObject(self, &CLGEOCODER_ATTRIBUTES_KEY);
}

@end

#pragma clang diagnostic pop
