#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "PCKHTTPInterface.h"
#import "NSURLConnectionDelegate.h"
#import "NSURLConnection+Spec.h"
#import "PSHKFakeResponses.h"
#import "PSHKFakeHTTPURLResponse.h"

#define HOST "example.com"
#define BASE_PATH "/v1/wibble/"
#define PATH "foo/bar"

@interface TestInterface : PCKHTTPInterface
- (NSURLConnection *)makeConnectionWithDelegate:(id<NSURLConnectionDelegate>)delegate;
@end

@implementation TestInterface
- (NSString *)host {
    return @HOST;
}

- (NSString *)basePath {
    return @BASE_PATH;
}

- (NSURLConnection *)makeConnectionWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionOfClass:[PCKHTTPConnection class] forPath:@PATH andDelegate:delegate secure:false];
}

- (NSURLConnection *)makeSecureConnectionWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionOfClass:[PCKHTTPConnection class] forPath:@PATH andDelegate:delegate secure:true];
}

@end

SPEC_BEGIN(PCKHTTPInterfaceSpec)

describe(@"PCKHTTPInterface", ^{
    __block TestInterface *interface;
    __block id mockDelegate;
    __block NSURLConnection *connection;
    __block NSURLRequest *request;

    beforeEach(^{
        [NSURLConnection resetAll];

        interface = [[TestInterface alloc] init];
        mockDelegate = [OCMockObject mockForProtocol:@protocol(NSURLConnectionDelegate)];
    });

    afterEach(^{
        [interface release];
    });

    describe(@"makeConnectionWithDelegate:", ^{
        beforeEach(^{
            [interface makeConnectionWithDelegate:mockDelegate];

            // Specs that complete the connection (success or failure) will remove it from the list
            // of active connections, which will release it.  Need to retain it here for specs that
            // use it so expectations aren't using a freed object.
            connection = [[[NSURLConnection connections] lastObject] retain];
            request = [connection request];
        });

        afterEach(^{
            [connection release];
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

                [connection returnResponse:response];
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
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]]connection:connection didReceiveResponse:[OCMArg any]];
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]]connection:connection didFailWithError:[OCMArg any]];

                [connection cancel];
            });

            it(@"should remove the connection from the active connections", ^{
                [[[connection retain] autorelease] cancel];
                assertThat([interface activeConnections], isNot(hasItem(connection)));
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

                [connection returnResponse:response];
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

            // Specs that complete the connection (success or failure) will remove it from the list
            // of active connections, which will release it.  Need to retain it here for specs that
            // use it so expectations aren't using a freed object.
            connection = [[[NSURLConnection connections] lastObject] retain];
            request = [connection request];
        });

        it(@"should use SSL", ^{
            assertThat([[request URL] scheme], equalTo(@"https"));
        });
    });
});

SPEC_END
