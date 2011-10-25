#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"

@interface SelfReferentialConnection : NSURLConnection
@end

@implementation SelfReferentialConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    return [super initWithRequest:request delegate:self startImmediately:startImmediately];
}

@end


using namespace Cedar::Matchers;

SPEC_BEGIN(NSURLConnectionSpec_Spec)

describe(@"NSURLConnection (spec extensions)", ^{
    __block NSURLRequest *request;
    __block id mockDelegate;
    __block NSURLConnection *connection;

    beforeEach(^{
        mockDelegate = [OCMockObject niceMockForProtocol:@protocol(NSURLConnectionDelegate)];
        NSURL *url = [NSURL URLWithString:@"http://example.com"];
        request = [NSURLRequest requestWithURL:url];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:mockDelegate];
    });

    afterEach(^{
        [connection release];
    });

    describe(@"+resetAll", ^{
        it(@"should remove all connections from the global list of connections", ^{
            expect([NSURLConnection connections]).to_not(be_empty());

            [NSURLConnection resetAll];
            expect([NSURLConnection connections]).to(be_empty());
        });
    });

    describe(@"on initialization", ^{
        it(@"should record the existence of the object in the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
        });

        it(@"should retain the request", ^{
            expect(request.retainCount).to(equal(2));
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                [connection release];
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
            });

            it(@"should not retain the delegate", ^{
                // One retain for alloc, one retain for the connections array.
                expect(connection.retainCount).to(equal(2));
            });
        });

        describe(@"when the delegate is not self", ^{
            it(@"should retain the delegate", ^{
                expect([mockDelegate retainCount]).to(equal(2));
            });
        });
    });

    describe(@"on destruction", ^{
        beforeEach(^{
            [NSURLConnection resetAll];
            [connection release]; connection = nil;
        });

        it(@"should release the request", ^{
            expect(request.retainCount).to(equal(1));
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                [connection release];
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
                [NSURLConnection resetAll];
            });

            it(@"should not explode", ^{
                [connection release]; connection = nil;
            });
        });

        describe(@"when the delegate is not self", ^{
            it(@"should release the delegate", ^{
                expect([mockDelegate retainCount]).to(equal(1));
            });
        });
    });

    describe(@"cancel", ^{
        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection cancel];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });
    });

    describe(@"receiveResponse:", ^{
        __block PSHKFakeHTTPURLResponse *response;

        beforeEach(^{
            response = [[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                 andHeaders:[NSDictionary dictionary]
                                                                    andBody:@"foo"]
                        autorelease];
        });

        it(@"should send the response to the delegate", ^{
            [[mockDelegate expect] connection:connection didReceiveResponse:response];
            [connection receiveResponse:response];
            [mockDelegate verify];
        });

        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection receiveResponse:response];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });

        it(@"should not call subsequent delegate methods if cancelled", ^{
            id mockDelegate = [OCMockObject mockForProtocol:@protocol(NSURLConnectionDelegate)];

            NSURLConnection * myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:mockDelegate];

            [[[mockDelegate expect] andDo:^(NSInvocation * inv){
                NSURLConnection * theConnection;
                [inv getArgument:&theConnection atIndex:2];
                [theConnection cancel];
            }] connection:myConnection didReceiveResponse:response];

            [myConnection release];
            [myConnection receiveResponse:response];

            [mockDelegate verify];
        });
    });

    describe(@"failWithError:", ^{
        __block NSError *error;

        beforeEach(^{
            error = [NSError errorWithDomain:@"domain" code:8 userInfo:nil];
        });

        it(@"should send the error to the delegate", ^{
            [[mockDelegate expect] connection:connection didFailWithError:error];
            [connection failWithError:error];
            [mockDelegate verify];
        });

        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection failWithError:error];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });
    });
});

SPEC_END
