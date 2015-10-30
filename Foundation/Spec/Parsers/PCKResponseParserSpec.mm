#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#import "Foundation+PivotalSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#import <Foundation+PivotalSpecHelper/Foundation+PivotalSpecHelper.h>
#endif

#import "PCKResponseParser.h"
#import "PCKParser.h"
#import "PCKParserDelegate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKResponseParserSpec)

describe(@"PCKResponseParser", ^{
    __block PCKResponseParser *responseParser;
    __block id<PCKParser, CedarDouble> parser;
    __block id<PCKParserDelegate, CedarDouble> successParserDelegate, errorParserDelegate;
    __block NSURLConnection *connection;
    __block id<NSURLConnectionDelegate, CedarDouble> connectionDelegate;

    beforeEach(^{
        parser = nice_fake_for(@protocol(PCKParser));
        successParserDelegate = nice_fake_for(@protocol(PCKParserDelegate));
        errorParserDelegate = nice_fake_for(@protocol(PCKParserDelegate));
        connection = nice_fake_for([NSURLConnection class]);
        connectionDelegate = nice_fake_for(@protocol(NSURLConnectionDataDelegate));

        responseParser = [[PCKResponseParser alloc] initWithParser:parser
                                              successParserDelegate:successParserDelegate
                                                errorParserDelegate:errorParserDelegate
                                                 connectionDelegate:connectionDelegate];
    });

    describe(@"on success response", ^{
        NSData *data = [NSData dataWithBytes:"12345" length:5];
        __block NSURLResponse *response;

        beforeEach(^{
            response = [[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200 andHeaders:[NSDictionary dictionary] andBody:nil];

            [responseParser connection:connection didReceiveResponse:response];
            [responseParser connection:connection didReceiveData:data];
            [responseParser connectionDidFinishLoading:connection];
        });

        it(@"should set the parser delegate to the success parser delegate", ^{
            parser should have_received("setDelegate:").with(successParserDelegate);
        });

        it(@"should pass returned data to the parser", ^{
            parser should have_received("parseChunk:");
        });

        it(@"should notify the connection delegate", ^{
            connectionDelegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
            connectionDelegate should_not have_received("connection:didReceiveData:");
            connectionDelegate should have_received("connectionDidFinishLoading:").with(connection);
        });
    });

    describe(@"on non-success response", ^{
        NSData *data = [NSData dataWithBytes:"12345" length:5];
        __block NSURLResponse *response;

        beforeEach(^{
            response = [[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:400 andHeaders:[NSDictionary dictionary] andBody:nil];

            [responseParser connection:connection didReceiveResponse:response];
            [responseParser connection:connection didReceiveData:data];
            [responseParser connectionDidFinishLoading:connection];
        });

        it(@"should set the parser delegate to the error parser delegate", ^{
            parser should have_received("setDelegate:").with(errorParserDelegate);
        });

        it(@"should pass returned data to the parser", ^{
            parser should have_received("parseChunk:");
        });

        it(@"should notify the connection delegate", ^{
            connectionDelegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
            connectionDelegate should_not have_received("connection:didReceiveData:");
            connectionDelegate should have_received("connectionDidFinishLoading:").with(connection);
        });
    });

    describe(@"on connection failure", ^{
        __block NSError *error;

        beforeEach(^{
            error = [NSError errorWithDomain:@"An error" code:7 userInfo:nil];
            [responseParser connection:connection didFailWithError:error];
        });

        it(@"should notify the connection delegate", ^{
            connectionDelegate should have_received("connection:didFailWithError:").with(connection).and_with(error);
        });

        it(@"should not send data to the parser", ^{
            parser should_not have_received("parseChunk:");
        });

        it(@"should not set the parser delegate", ^{
            parser should_not have_received("setDelegate:");
        });
    });
});

SPEC_END
