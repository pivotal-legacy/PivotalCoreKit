#import "UISpecHelper.h"
#import "OCMock.h"

#import "AWebViewController.h"
#import "UIWebView+Spec.h"

namespace Cedar { namespace Matchers {
    class BeLoading : public Base<> {
    public:
        virtual NSString * failure_message_end() const { return @"be loading"; }
        inline bool matches(UIWebView * const webView) const { return webView.loading; }
    };

    inline BeLoading be_loading() {
        return BeLoading();
    }
}}

using namespace Cedar::Matchers;

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
                expect(webView.request).to(equal(request));
            });

            it(@"should mark the web view as loading", ^{
                executeOperation();
                expect(webView).to(be_loading());
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
                expect(webView.request).to(be_nil());
            });

            it(@"should not mark the web view as loading", ^{
                expect(webView).to_not(be_loading());
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
            executeOperation = [[^{
                [webView loadRequest:request];
            } copy] autorelease];
            [context setObject:executeOperation forKey:@"executeOperation"];

            UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
            NSValue *navigationTypeValue = [NSValue valueWithBytes:&navigationType objCType:@encode(UIWebViewNavigationType)];
            [context setObject:navigationTypeValue forKey:@"navigationType"];
        });

        itShouldBehaveLike(@"an operation that loads a request");
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
                expect(webView).to_not(be_loading());
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
                expect(webView).to_not(be_loading());
            });

            it(@"should maintain the loaded request", ^{
                [webView finishLoad];
                expect(webView.request).to(equal(request));
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
                expect(result).to(be_nil());
            });

            it(@"should record the script", ^{
                expect(webView.executedJavaScripts).to(contain(js));
            });
        });

        describe(@"with a return value", ^{
            NSString *returnValue = @"42";

            beforeEach(^{
                [webView setReturnValue:returnValue forJavaScript:js];
                result = [webView stringByEvaluatingJavaScriptFromString:js];
            });

            it(@"should return the registered value", ^{
                expect(result).to(equal(returnValue));
            });

            it(@"should record the script", ^{
                expect(webView.executedJavaScripts).to(contain(js));
            });
        });

        describe(@"with a return block", ^{
            __block int value = 0;

            beforeEach(^{
                [webView setReturnBlock:^{ return (NSString *)[NSString stringWithFormat:@"%d", value]; } forJavaScript:js];
            });

            it(@"should return the value returned by the block", ^{
                expect([webView stringByEvaluatingJavaScriptFromString:js]).to(equal(@"0"));

                ++value;
                expect([webView stringByEvaluatingJavaScriptFromString:js]).to(equal(@"1"));
            });

            it(@"should record the script", ^{
                [webView stringByEvaluatingJavaScriptFromString:js];
                expect(webView.executedJavaScripts).to(contain(js));
            });
        });
    });

    describe(@"frame", ^{
        it(@"should not blow up", ^{
            [webView frame];
        });
    });

    describe(@"setFrame:", ^{
        it(@"should not blow up", ^{
            webView.frame = CGRectMake(0, 0, 0, 0);
        });
    });

    describe(@"setDataDetectorTypes:", ^{
        it(@"should not blow up", ^{
            [webView setDataDetectorTypes:1];
        });
    });

    describe(@"dataDetectorTypes", ^{
        it(@"should default to UIDataDetectorTypePhoneNumber", ^{
            expect(webView.dataDetectorTypes).to(equal((NSUInteger)UIDataDetectorTypePhoneNumber));
        });

        it(@"should return any previous set value", ^{
            UIDataDetectorTypes setTypes = UIDataDetectorTypeCalendarEvent | UIDataDetectorTypeAddress;

            webView.dataDetectorTypes = setTypes;
            expect(webView.dataDetectorTypes).to(equal(setTypes));
        });
    });

    describe(@"allowsInlineMediaPlayback", ^{
        it(@"should not explode, however quietly", ^{
            [webView allowsInlineMediaPlayback];
        });
    });

    describe(@"setAllowsInlineMediaPlayback", ^{
        beforeEach(^{
            expect(webView.allowsInlineMediaPlayback).to_not(be_truthy());
            webView.allowsInlineMediaPlayback = YES;
        });

        it(@"should return the previously set value", ^{
            expect(webView.allowsInlineMediaPlayback).to(be_truthy());
        });
    });

    describe(@"loadHTMLString:baseURL:", ^{
        NSString *html = @"some HTML";
        NSURL *baseURL = [NSURL URLWithString:@"a-path"];

        beforeEach(^{
            [webView loadHTMLString:html baseURL:baseURL];
        });

        it(@"should record the loaded HTML", ^{
            expect(webView.loadedHTMLString).to(equal(html));
        });

        it(@"should record the baseURL", ^{
            expect(webView.loadedBaseURL).to(equal(baseURL));
        });
    });

    describe(@"when loaded from a XIB", ^{
        beforeEach(^{
            AWebViewController *controller = [[[AWebViewController alloc] initWithNibName:@"AWebViewController" bundle:nil] autorelease];
            // Load the view.
            expect(controller.view).to_not(be_nil());
            webView = controller.webView;
            webView.delegate = delegate;
        });

        describe(@"loadRequest:", ^{
            __block void (^executeOperation)();

            beforeEach(^{
                NSMutableDictionary *context = [SpecHelper specHelper].sharedExampleContext;
                executeOperation = [[^{
                    [webView loadRequest:request];
                } copy] autorelease];
                [context setObject:executeOperation forKey:@"executeOperation"];

                UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
                NSValue *navigationTypeValue = [NSValue valueWithBytes:&navigationType objCType:@encode(UIWebViewNavigationType)];
                [context setObject:navigationTypeValue forKey:@"navigationType"];
            });

            itShouldBehaveLike(@"an operation that loads a request");
        });
    });
});

SPEC_END
