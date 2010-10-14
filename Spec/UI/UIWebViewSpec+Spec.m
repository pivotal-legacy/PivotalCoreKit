#import "SpecHelper.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "OCMock.h"

#import "UIWebView+Spec.h"

SPEC_BEGIN(UIWebViewSpec)

describe(@"UIWebView (spec extensions)", ^{
    typedef void (^AndDoBlock)(NSInvocation *);
    AndDoBlock returnYes = ^(NSInvocation *invocation) {
        BOOL yes = YES;
        [invocation setReturnValue:&yes];
    };

    AndDoBlock returnNo = ^(NSInvocation *invocation) {
        BOOL no = NO;
        [invocation setReturnValue:&no];
    };

    __block id delegate;
    __block UIWebView *webView;

    NSString *requestString = @"http://example.com/foo";
    __block NSURL *url;
    __block NSURLRequest *request;

    beforeEach(^{
        delegate = [OCMockObject niceMockForProtocol:@protocol(UIWebViewDelegate)];
        webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        webView.delegate = delegate;

        url = [NSURL URLWithString:requestString];
        request = [NSURLRequest requestWithURL:url];
    });

    sharedExamplesFor(@"an operation that loads a request", ^(NSDictionary *context) {
        __block void (^executeOperation)();
        __block UIWebViewNavigationType navigationType;

        beforeEach(^{
            executeOperation = [context objectForKey:@"executeOperation"];
            [[context objectForKey:@"navigationType"] getValue:&navigationType];
        });

        it(@"should send the webView:shouldStartLoadWithRequest:navigationType message to the delegate with the appropriate navigation type", ^{
            [[delegate expect] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];

            executeOperation();

            [delegate verify];
        });

        describe(@"if the delegate allows the request to load", ^{
            beforeEach(^{
                [[[delegate stub] andDo:returnYes] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
            });

            it(@"should have a pending request", ^{
                executeOperation();
                assertThat(webView.request, equalTo(request));
            });

            it(@"should mark the web view as loading", ^{
                executeOperation();
                assertThatBool(webView.loading, equalToBool(YES));
            });

            it(@"should send the webViewDidStartLoad: message to the delegate", ^{
                [[delegate expect] webViewDidStartLoad:webView];

                executeOperation();
                [delegate verify];
            });
        });

        describe(@"if the delegate does not allow the request to load", ^{
            beforeEach(^{
                [[[delegate stub] andDo:returnNo] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
                executeOperation();
            });

            it(@"should not have a pending request", ^{
                assertThat(webView.request, nilValue());
            });

            it(@"should not mark the web view as loading", ^{
                assertThatBool(webView.loading, equalToBool(NO));
            });
        });

        describe(@"with a request already loading", ^{
            it(@"should throw an exception", ^{
                @try {
                    [[[delegate stub] andDo:returnYes] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
                    executeOperation();
                    executeOperation();
                } @catch (NSException *) {
                    return;
                }
                fail(@"No exception!");
            });
        });

        describe(@"with a request that previously completed loading", ^{
            it(@"should succeed", ^{
                [[[delegate stub] andDo:returnYes] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
                executeOperation();
                [webView finishLoad];
                executeOperation();
            });
        });
    });

    describe(@"loadRequest:", ^{
        __block void (^executeOperation)();

        beforeEach(^{
            NSMutableDictionary *context = [SpecHelper specHelper].sharedExampleContext;
            executeOperation = [^{
                [webView loadRequest:request];
            } copy];
            [context setObject:executeOperation forKey:@"executeOperation"];

            UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
            NSValue *navigationTypeValue = [NSValue valueWithBytes:&navigationType objCType:@encode(UIWebViewNavigationType)];
            [context setObject:navigationTypeValue forKey:@"navigationType"];
        });

        itShouldBehaveLike(@"an operation that loads a request");

        afterEach(^{
            [executeOperation release];
        });
    });

    describe(@"sendClickRequest:", ^{
        __block void (^executeOperation)();

        beforeEach(^{
            NSMutableDictionary *context = [SpecHelper specHelper].sharedExampleContext;
            executeOperation = [^{
                [webView sendClickRequest:request];
            } copy];
            [context setObject:executeOperation forKey:@"executeOperation"];

            UIWebViewNavigationType navigationType = UIWebViewNavigationTypeLinkClicked;
            NSValue *navigationTypeValue = [NSValue valueWithBytes:&navigationType objCType:@encode(UIWebViewNavigationType)];
            [context setObject:navigationTypeValue forKey:@"navigationType"];
        });

        itShouldBehaveLike(@"an operation that loads a request");

        afterEach(^{
            [executeOperation release];
        });
    });

    describe(@"finishLoad", ^{
        describe(@"with no loading request", ^{
            beforeEach(^{
                assertThatBool(webView.loading, equalToBool(NO));
            });

            it(@"should throw an exception", ^{
                @try {
                    [webView finishLoad];
                } @catch (NSException *) {
                    return;
                }
                fail(@"No exception!");
            });
        });

        describe(@"with a loading request", ^{
            beforeEach(^{
                [[[delegate stub] andDo:returnYes] webView:webView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeOther];
                [webView loadRequest:request];
            });

            it(@"should send the webViewDidFinishLoad: message to the delegate", ^{
                [[delegate expect] webViewDidFinishLoad:webView];

                [webView finishLoad];
                [delegate verify];
            });

            it(@"should mark the web view as no longer loading", ^{
                [webView finishLoad];
                assertThatBool(webView.loading, equalToBool(NO));
            });

            it(@"should maintain the loaded request", ^{
                [webView finishLoad];
                assertThat(webView.request, equalTo(request));
            });
        });
    });

    describe(@"stringByEvaluatingJavaScriptFromString:", ^{
        NSString *js = @"someRandomJavascript();";
        __block NSString *result;

        describe(@"without a return value", ^{
            beforeEach(^{
                result = [webView stringByEvaluatingJavaScriptFromString:js];
            });

            it(@"should return nil", ^{
                assertThat(result, nilValue());
            });

            it(@"should record the script", ^{
                assertThat(webView.executedJavaScripts, hasItem(js));
            });
        });

        describe(@"with a return value", ^{
            NSString *returnValue = @"42";

            beforeEach(^{
                [webView setReturnValue:returnValue forJavaScript:js];
                result = [webView stringByEvaluatingJavaScriptFromString:js];
            });

            it(@"should return the registered value", ^{
                assertThat(result, equalTo(returnValue));
            });

            it(@"should record the script", ^{
                assertThat(webView.executedJavaScripts, hasItem(js));
            });
        });

        describe(@"with a return block", ^{
            __block int value = 0;

            beforeEach(^{
                [webView setReturnBlock:^{ return (NSString *)[NSString stringWithFormat:@"%d", value]; } forJavaScript:js];
            });

            it(@"should return the value returned by the block", ^{
                assertThat([webView stringByEvaluatingJavaScriptFromString:js], equalTo(@"0"));

                ++value;
                assertThat([webView stringByEvaluatingJavaScriptFromString:js], equalTo(@"1"));
            });

            it(@"should record the script", ^{
                [webView stringByEvaluatingJavaScriptFromString:js];
                assertThat(webView.executedJavaScripts, hasItem(js));
            });
        });
    });

    describe(@"frame", ^{
        it(@"should not blow up", ^{
            webView.frame;
        });
    });

    describe(@"setFrame:", ^{
        it(@"should not blow up", ^{
            webView.frame = CGRectMake(0, 0, 0, 0);
        });
    });
});

SPEC_END
