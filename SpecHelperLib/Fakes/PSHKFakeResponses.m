#import "PSHKFakeResponses.h"
#import "PSHKFakeHTTPURLResponse.h"

@interface PSHKFakeResponses (private)
- (NSString *)responseBodyForStatusCode:(int)statusCode;
- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode;
- (NSString *)fakeResponsesDirectory;
@end

@implementation PSHKFakeResponses

+ (id)responsesForRequest:(NSString *)request {
    return [[[[self class] alloc] initForRequest:request] autorelease];
}

- (id)initForRequest:(NSString *)request {
    if (self = [super init]) {
        request_ = [request copy];
    }
    return self;
}

- (void)dealloc {
    [request_ release];
    [super dealloc];
}

- (PSHKFakeHTTPURLResponse *)success {
    return [self responseForStatusCode:200];
}

- (PSHKFakeHTTPURLResponse *)badRequest {
    return [self responseForStatusCode:400];
}

#pragma mark private interface


- (NSString *)responseBodyForStatusCode:(int)statusCode {
    NSString *fakeResponsesDirectory = [self fakeResponsesDirectory];
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:fakeResponsesDirectory, request_, [NSString stringWithFormat:@"%d.txt", statusCode], nil]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    }
    @throw [NSException exceptionWithName:@"FileNotFound" reason:[NSString stringWithFormat:@"No %d response found for request '%@'", statusCode, request_] userInfo:nil];
}

- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode {
    return [[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:statusCode
                                                     andHeaders:[NSDictionary dictionary]
                                                        andBody:[self responseBodyForStatusCode:statusCode]]
            autorelease];
}

static NSString *UNBUNDLED_FAKE_RESPONSES_DIRECTORY = @"../../Spec/Fixtures/FakeResponses";

- (NSString *)fakeResponsesDirectory {

    if ([[NSFileManager defaultManager] fileExistsAtPath:UNBUNDLED_FAKE_RESPONSES_DIRECTORY]) {
        return UNBUNDLED_FAKE_RESPONSES_DIRECTORY;
    } else {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *bundlePath = [mainBundle bundlePath];
        return [bundlePath stringByAppendingString:@"/Fixtures/FakeResponses"];
    }
}

@end
