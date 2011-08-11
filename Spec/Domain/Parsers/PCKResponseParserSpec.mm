#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#import <PivotalSpecHelperKit/PivotalSpecHelperKit.h>

#import "PCKResponseParser.h"
#import "PCKHTTPConnectionDelegate.h"
#import "PCKParser.h"

SPEC_BEGIN(PCKResponseParserSpec)

describe(@"PCKResponseParser", ^{
    __block PCKResponseParser *responseParser;
    __block id mockParser, mockDelegate;

    beforeEach(^{
        mockParser = [OCMockObject niceMockForProtocol:@protocol(PCKParser)];
        mockDelegate = [OCMockObject niceMockForProtocol:@protocol(PCKHTTPConnectionDelegate)];
        responseParser = [[PCKResponseParser alloc] initWithParser:mockParser andDelegate:mockDelegate];
    });

	afterEach(^{
	    [responseParser release];
	});

    describe(@"on success response", ^{
        NSData *data = [NSData dataWithBytes:"12345" length:5];
        __block NSURLResponse *response;
        __block void (^returnResponse)();

        beforeEach(^{
            response = [[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200 andHeaders:[NSDictionary dictionary] andBody:nil] autorelease];
            returnResponse = [^{
                [responseParser connection:nil didReceiveResponse:response];
                [responseParser connection:nil didReceiveData:data];
                [responseParser connectionDidFinishLoading:nil];
            } copy];

        });

        it(@"should pass returned data to the parser", ^{
            [[mockParser expect] parseChunk:data];

            returnResponse();

            [mockParser verify];
        });

        it(@"should notify the delegate of success", ^{
            [[mockDelegate expect] connection:nil didReceiveResponse:response];
            [[mockDelegate expect] connectionDidFinishLoading:nil];

            returnResponse();

            [mockDelegate verify];
        });
    });

    describe(@"on connection failure", ^{
        it(@"should notify the delegate of the error", ^{
            NSError *error = [NSError errorWithDomain:@"An error" code:7 userInfo:nil];
            [[mockDelegate expect] connection:nil didFailWithError:error];

            [responseParser connection:nil didFailWithError:error];

            [mockDelegate verify];
        });
    });
});

SPEC_END
