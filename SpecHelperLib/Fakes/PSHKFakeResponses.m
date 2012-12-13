#import "PSHKFakeResponses.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "PSHKFixtures.h"

@interface PSHKFakeResponses (Private)
- (NSString *)responseBodyForStatusCode:(int)statusCode;
- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode;
- (NSString *)fakeResponsesDirectory;
@end

@implementation PSHKFakeResponses

+ (id)responsesForRequest:(NSString *)request {
    return [[[[self class] alloc] initForRequest:request] autorelease];
}

- (id)initForRequest:(NSString *)request {
    if ((self = [super init])) {
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

- (PSHKFakeHTTPURLResponse *)authenticationFailure {
    return [self responseForStatusCode:401];
}

- (PSHKFakeHTTPURLResponse *)conflict {
    return [self responseForStatusCode:409];
}

- (PSHKFakeHTTPURLResponse *)serverError {
    return [self responseForStatusCode:500];
}

- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode {
    return [[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:statusCode
                                                     andHeaders:[NSDictionary dictionary]
                                                        andBody:[self responseBodyForStatusCode:statusCode]]
            autorelease];
}

#pragma mark Private interface

- (NSString *)responseBodyForStatusCode:(int)statusCode {
    NSString *fakeResponsesDirectory = [self fakeResponsesDirectory];
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:fakeResponsesDirectory, request_, [NSString stringWithFormat:@"%d.txt", statusCode], nil]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    }

    NSString *message = [NSString stringWithFormat:@"No %d response found for request '%@'\nCurrent working directory:'%@'\nFake responses directory: '%@'",
                         statusCode,
                         request_,
                         [[NSFileManager defaultManager] currentDirectoryPath],
                         fakeResponsesDirectory];
    @throw [NSException exceptionWithName:@"FileNotFound" reason:message userInfo:nil];
}

- (NSString *)fakeResponsesDirectory {
    NSString *fakeResponsesDirectory = [[PSHKFixtures directory] stringByAppendingPathComponent:@"FakeResponses"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fakeResponsesDirectory]) {
        return fakeResponsesDirectory;
    } else {
        return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fakeResponsesDirectory];
    }
}

@end
