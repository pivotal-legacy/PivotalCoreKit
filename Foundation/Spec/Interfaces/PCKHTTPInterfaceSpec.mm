#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKHTTPInterface.h"
#import "NSURLConnection+Spec.h"
#import "PSHKFakeResponses.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"

#define HOST "example.com"
#define BASE_URL_PATH "/v1/wibble/"
#define PATH "foo/bar"

@interface TestInterface : PCKHTTPInterface
- (NSURLConnection *)makeConnectionWithDelegate:(id<NSURLConnectionDataDelegate>)delegate;
@end

@implementation TestInterface
- (NSString *)host {
    return @HOST;
}

- (NSString *)baseURLPath {
    return @BASE_URL_PATH;
}

- (NSURLConnection *)makeConnectionWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:false andDelegate:delegate];
}

- (NSURLConnection *)makeSecureConnectionWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:true andDelegate:delegate];
}

- (NSURLConnection *)makeConnectionWithHeaders:(NSDictionary *)headers andDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:@PATH secure:true andDelegate:delegate withRequestSetup:^(NSMutableURLRequest *request) {
        [request setAllHTTPHeaderFields:headers];
    }];
}

@end


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKHTTPInterfaceSpec)

describe(@"PCKHTTPInterface", ^{
    __block TestInterface *interface;
    __block id<NSURLConnectionDataDelegate, CedarDouble> delegate;
    __block NSURLConnection *connection;
    __block NSURLRequest *request;

    beforeEach(^{
        interface = [[TestInterface alloc] init];
        delegate = nice_fake_for(@protocol(NSURLConnectionDataDelegate));
    });

    describe(@"makeConnectionWithDelegate:", ^{
        beforeEach(^{
            [interface makeConnectionWithDelegate:delegate];

            connection = [[NSURLConnection connections] lastObject];
            request = [connection request];
        });

        it(@"should send one HTTP request", ^{
            expect([NSURLConnection connections].count).to(equal(1));
        });

        it(@"should generate the target URI from the subclass-specific host and base path, along with the specified path", ^{
            expect(request.URL.host).to(equal(@HOST));
            expect(request.URL.path).to(equal(@BASE_URL_PATH PATH));
        });

        it(@"should use the GET method", ^{
            expect(request.HTTPMethod).to(equal(@"GET"));
        });

        it(@"should not use SSL", ^{
            expect(request.URL.scheme).to(equal(@"http"));
        });

        it(@"should add the new connection to the active connections", ^{
            expect(interface.activeConnections).to(contain(connection));
        });

        describe(@"when called multiple times", ^{
            it(@"should cache the base URL", ^{
                spy_on(interface);
                [interface makeConnectionWithDelegate:delegate];

                interface should_not have_received("host");
                interface should_not have_received("baseURLPath");
            });
        });

        describe(@"on success", ^{
            __block PSHKFakeHTTPURLResponse *response;

            beforeEach(^{
                response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] success];
                [connection receiveResponse:response];
            });

            it(@"should pass along the success response and data, and notify the delegate when the request has completed", ^{
                delegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
                delegate should have_received("connection:didReceiveData:").with(connection).and_with(response.bodyData);
                delegate should have_received("connectionDidFinishLoading:").with(connection);
            });

            it(@"should remove the connection from the active connections", ^{
                expect(interface.activeConnections).to_not(contain(connection));
            });
        });

        describe(@"on cancel", ^{
            it(@"should not notify the delegate that the connection completed (because it didn't)", ^{
                [connection cancel];

                delegate should_not have_received("connection:didReceiveResponse:");
                delegate should_not have_received("connection:didFailWithError:");
            });

            it(@"should remove the connection from the active connections", ^{
                [connection cancel];
                expect(interface.activeConnections).to_not(contain(connection));
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
                NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username" password:@"password" persistence:NSURLCredentialPersistenceNone];
                [connection sendAuthenticationChallengeWithCredential:credential];
            });

            it(@"should request credentials from the delegate", ^{
                delegate should have_received("connection:didReceiveAuthenticationChallenge:").with(connection).and_with(Arguments::anything);
            });

            describe(@"when the client chooses to cancel the authentication challenge", ^{
                beforeEach(^{
                    NSURLAuthenticationChallenge<CedarDouble> *challenge = fake_for([NSURLAuthenticationChallenge class]);
#pragma clang diganostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [connection.delegate connection:connection didCancelAuthenticationChallenge:challenge];
#pragma clang diagnostic pop
                });

                it(@"should remove the connection from the active connections", ^{
                    expect(interface.activeConnections).to_not(contain(connection));
                });
            });
        });

        describe(@"on failure", ^{
            __block PSHKFakeHTTPURLResponse *response;

            beforeEach(^{
                response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] badRequest];
                [connection receiveResponse:response];
            });

            it(@"should pass along the failure response, and notify the delegate when the request has completed", ^{
                delegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
                delegate should have_received("connection:didReceiveData:").with(connection).and_with(response.bodyData);
                delegate should have_received("connectionDidFinishLoading:").with(connection);
            });

            it(@"should remove the connection from the active connections", ^{
                expect(interface.activeConnections).to_not(contain(connection));
            });
        });

        describe(@"on connection error", ^{
            __block NSError *error;

            beforeEach(^{
                error = [NSError errorWithDomain:@"StoryAccepter" code:-1 userInfo:nil];
                [connection failWithError:error];
            });

            it(@"should notify the delegate of the error", ^{
                delegate should have_received("connection:didFailWithError:").with(connection).and_with(error);
            });

            it(@"should remove the connection from the active connections", ^{
                expect(interface.activeConnections).to_not(contain(connection));
            });
        });
    });

    describe(@"makeSecureConnectionWithDelegate:", ^{
        beforeEach(^{
            [interface makeSecureConnectionWithDelegate:delegate];
            connection = [[NSURLConnection connections] lastObject];
            request = [connection request];
        });

        it(@"should use SSL", ^{
            expect(request.URL.scheme).to(equal(@"https"));
        });
    });

    describe(@"makeConnectionWithHeaders:andDelegate:", ^{
        it(@"should include the specified headers in the request", ^{
            NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"wibble", @"header1", nil];
            NSURLConnection *connection = [interface makeConnectionWithHeaders:headers andDelegate:delegate];

            expect([connection.request valueForHTTPHeaderField:@"header1"]).to(equal(@"wibble"));
        });
    });

    describe(@"connectionForPath:secure:andDelegate:withRequestSetup:", ^{
        it(@"should set up the request as specified by the block", ^{
            NSURLConnection *connection = [interface connectionForPath:@PATH secure:false andDelegate:delegate withRequestSetup:^(NSMutableURLRequest *request) {
                request.HTTPMethod = @"POST";
            }];

            expect(connection.request.HTTPMethod).to(equal(@"POST"));
        });
    });

    describe(@"requestForPath:secure:", ^{
        context(@"when secure", ^{
            beforeEach(^{
                request = [interface requestForPath:@PATH secure:YES];
            });

            it(@"should generate the target URI from the subclass-specific host and base path, along with the specified path", ^{
                expect(request.URL.host).to(equal(@HOST));
                expect(request.URL.path).to(equal(@BASE_URL_PATH PATH));
            });

            it(@"should use the GET method", ^{
                expect(request.HTTPMethod).to(equal(@"GET"));
            });

            it(@"should use SSL", ^{
                expect(request.URL.scheme).to(equal(@"https"));
            });
        });

        context(@"when not secure", ^{
            beforeEach(^{
                request = [interface requestForPath:@PATH secure:NO];
            });

            it(@"should generate the target URI from the subclass-specific host and base path, along with the specified path", ^{
                expect(request.URL.host).to(equal(@HOST));
                expect(request.URL.path).to(equal(@BASE_URL_PATH PATH));
            });

            it(@"should use the GET method", ^{
                expect(request.HTTPMethod).to(equal(@"GET"));
            });

            it(@"should not use SSL", ^{
                expect(request.URL.scheme).to(equal(@"http"));
            });
        });
    });

    describe(@"connectionForRequest:delegate:", ^{
        __block NSURLRequest *request;

        beforeEach(^{
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            connection = [interface connectionForRequest:request delegate:nil];
        });

        it(@"should send one HTTP request", ^{
            expect([NSURLConnection connections].count).to(equal(1));
        });

        it(@"should use the specified request object", ^{
            expect(connection.request).to(equal(request));
        });

        it(@"should add the new connection to the active connections", ^{
            expect(interface.activeConnections).to(contain(connection));
        });
    });
});

SPEC_END
