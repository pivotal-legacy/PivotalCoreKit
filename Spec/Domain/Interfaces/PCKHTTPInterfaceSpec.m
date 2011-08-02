#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "PCKHTTPInterface.h"
#import "PCKHTTPConnectionDelegate.h"
#import "NSURLConnection+Spec.h"
#import "PSHKFakeResponses.h"
#import "PSHKFakeHTTPURLResponse.h"

#define HOST "example.com"
#define BASE_PATH "/v1/wibble/"
#define PATH "foo/bar"

@interface TestInterface : PCKHTTPInterface
- (NSURLConnection *)makeConnectionWithDelegate:(id<PCKHTTPConnectionDelegate>)delegate;
@end

@implementation TestInterface
- (NSString *)host {
    return @HOST;
}

- (NSString *)basePath {
    return @BASE_PATH;
}

- (NSURLConnection *)makeConnectionWithDelegate:(id<PCKHTTPConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:false andDelegate:delegate];
}

- (NSURLConnection *)makeSecureConnectionWithDelegate:(id<PCKHTTPConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:true andDelegate:delegate];
}

- (NSURLConnection *)makeConnectionWithHeaders:(NSDictionary *)headers andDelegate:(id<PCKHTTPConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:true andDelegate:delegate withRequestSetup:^(NSMutableURLRequest *request) {
        [request setAllHTTPHeaderFields:headers];
    }];
}

@end

SPEC_BEGIN(PCKHTTPInterfaceSpec)

describe(@"PCKHTTPInterface", ^{
    __block TestInterface *interface;
    __block id mockDelegate;
    __block NSURLConnection *connection;
    __block NSURLRequest *request;

    beforeEach(^{
        interface = [[TestInterface alloc] init];
        mockDelegate = [OCMockObject mockForProtocol:@protocol(PCKHTTPConnectionDelegate)];
    });

    afterEach(^{
        [interface release];
    });

    describe(@"makeConnectionWithDelegate:", ^{
        beforeEach(^{
            [interface makeConnectionWithDelegate:mockDelegate];

            connection = [[NSURLConnection connections] lastObject];
            request = [connection request];
        });

        it(@"should send one HTTP request", ^{
            assertThatInt([[NSURLConnection connections] count], equalToInt(1));
        });

        it(@"should generate the target URI from the subclass-specific host and base path, along with the specified path", ^{
            assertThat([[request URL] host], equalTo(@HOST));
            assertThat([[request URL] path], equalTo(@BASE_PATH PATH));
        });

        it(@"should use the GET method", ^{
            assertThat([request HTTPMethod], equalTo(@"GET"));
        });

        it(@"should not use SSL", ^{
            assertThat([[request URL] scheme], equalTo(@"http"));
        });

        it(@"should add the new connection to the active connections", ^{
            assertThat([interface activeConnections], hasItem(connection));
        });

        describe(@"when called multiple times", ^{
            it(@"should cache the base URL", ^{
                id interfaceStub = [OCMockObject partialMockForObject:interface];
                [[[interfaceStub stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]] host];
                [[[interfaceStub stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]] basePath];
                [interface makeConnectionWithDelegate:mockDelegate];
            });
        });

        describe(@"on success", ^{
            beforeEach(^{
                PSHKFakeHTTPURLResponse *response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] success];
                [[mockDelegate expect] connection:connection didReceiveResponse:response];
                [[mockDelegate expect] connection:connection didReceiveData:[[response body] dataUsingEncoding:NSUTF8StringEncoding]];
                [[mockDelegate expect] connectionDidFinishLoading:connection];

                [connection receiveResponse:response];
            });

            it(@"should pass along the success response and data, and notify the delegate when the request has completed", ^{
                [mockDelegate verify];
            });

            it(@"should remove the connection from the active connections", ^{
                assertThat([interface activeConnections], isNot(hasItem(connection)));
            });
        });

        describe(@"on cancel", ^{
            it(@"should not notify the delegate that the connection completed (because it didn't)", ^{
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]] connection:connection didReceiveResponse:[OCMArg any]];
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]] connection:connection didFailWithError:[OCMArg any]];

                [connection cancel];
            });

            it(@"should remove the connection from the active connections", ^{
                [[[connection retain] autorelease] cancel];
                assertThat([interface activeConnections], isNot(hasItem(connection)));
            });

            it(@"should cancel the connection BEFORE removing itself from active connections and deallocating", ^{
                // Remove the connection from the test-specific connections container so it's not
                // retained by any test code.
                [NSURLConnection resetAll];
                [connection cancel];
            });
        });

        describe(@"on authentication challenge", ^{
            beforeEach(^{
                [[mockDelegate expect] connection:connection didReceiveAuthenticationChallenge:[OCMArg any]];
                NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username" password:@"password" persistence:NSURLCredentialPersistenceNone];

                [connection sendAuthenticationChallengeWithCredential:credential];
            });

            it(@"should request credentials from the delegate", ^{
                [mockDelegate verify];
            });

            describe(@"when the client chooses to cancel the authentication challenge", ^{
                beforeEach(^{
                    id mockChallenge = [OCMockObject mockForClass:[NSURLAuthenticationChallenge class]];

                    [[mockDelegate expect] connection:connection didCancelAuthenticationChallenge:mockChallenge];
                    [[connection delegate] connection:connection didCancelAuthenticationChallenge:mockChallenge];
                });

                it(@"should remove the connection from the active connections", ^{
                    assertThat([interface activeConnections], isNot(hasItem(connection)));
                });

                it(@"should notify the connection delegate", ^{
                    [mockDelegate verify];
                });
            });
        });

        describe(@"on failure", ^{
            beforeEach(^{
                PSHKFakeHTTPURLResponse *response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] badRequest];
                [[mockDelegate expect] connection:connection didReceiveResponse:response];
                [[mockDelegate stub] connection:connection didReceiveData:[OCMArg any]];
                [[mockDelegate expect] connectionDidFinishLoading:connection];

                [connection receiveResponse:response];
            });

            it(@"should pass along the failure response, and notify the delegate when the request has completed", ^{
                [mockDelegate verify];
            });

            it(@"should remove the connection from the active connections", ^{
                assertThat([interface activeConnections], isNot(hasItem(connection)));
            });
        });

        describe(@"on connection error", ^{
            beforeEach(^{
                NSError *error = [NSError errorWithDomain:@"StoryAccepter" code:-1 userInfo:nil];
                [[mockDelegate expect] connection:connection didFailWithError:error];

                [[connection delegate] connection:connection didFailWithError:error];
            });

            it(@"should notify the delegate of the error", ^{
                [mockDelegate verify];
            });

            it(@"should remove the connection from the active connections", ^{
                assertThat([interface activeConnections], isNot(hasItem(connection)));
            });
        });
    });

    describe(@"makeSecureConnectionWithDelegate:", ^{
        beforeEach(^{
            [interface makeSecureConnectionWithDelegate:mockDelegate];
            connection = [[NSURLConnection connections] lastObject];
            request = [connection request];
        });

        it(@"should use SSL", ^{
            assertThat([[request URL] scheme], equalTo(@"https"));
        });
    });

    describe(@"makeConnectionWithHeaders:andDelegate:", ^{
        it(@"should include the specified headers in the request", ^{
            NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"wibble", @"header1", nil];
            NSURLConnection *connection = [interface makeConnectionWithHeaders:headers andDelegate:mockDelegate];
            assertThat([[connection request] valueForHTTPHeaderField:@"header1"], equalTo(@"wibble"));
        });
    });

    describe(@"connectionForPath:secure:andDelegate:withRequestSetup:", ^{
        it(@"should set up the request as specified by the block", ^{
            NSURLConnection *connection = [interface connectionForPath:@PATH secure:false andDelegate:mockDelegate withRequestSetup:^(NSMutableURLRequest *request) {
                request.HTTPMethod = @"POST";
            }];

            assertThat(connection.request.HTTPMethod, equalTo(@"POST"));
        });
    });
});

SPEC_END
