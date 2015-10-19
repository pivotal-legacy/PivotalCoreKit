#import "CDRSpecHelper.h"

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
using namespace Cedar::Doubles;

SPEC_BEGIN(UIWebViewSpecExtensionsSpec)

describe(@"UIWebView (spec extensions)", ^{
    __block id<UIWebViewDelegate, CedarDouble> delegate;
    __block UIWebView *webView;

    NSString *requestString = @"http://example.com/foo";
    __block NSURL *url;
    __block NSURLRequest *request;

    beforeEach(^{
        delegate = nice_fake_for(@protocol(UIWebViewDelegate));
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
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
            executeOperation();
            delegate should have_received("webView:shouldStartLoadWithRequest:navigationType:").with(webView).and_with(request).and_with(navigationType);
        });

        describe(@"if the delegate allows the request to load", ^{
            beforeEach(^{
                delegate stub_method("webView:shouldStartLoadWithRequest:navigationType:").and_return(YES);
                executeOperation();
            });

            it(@"should have a pending request", ^{
                expect(webView.request).to(equal(request));
            });

            it(@"should mark the web view as loading", ^{
                expect(webView).to(be_loading());
            });

            it(@"should send the webViewDidStartLoad: message to the delegate", ^{
                delegate should have_received("webViewDidStartLoad:").with(webView);
            });
        });

        describe(@"if the delegate does not allow the request to load", ^{
            beforeEach(^{
                delegate stub_method("webView:shouldStartLoadWithRequest:navigationType:").and_return(NO);
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
                delegate stub_method("webView:shouldStartLoadWithRequest:navigationType:").and_return(YES);
                executeOperation();
                ^{ executeOperation(); } should raise_exception;
            });
        });

        describe(@"with a request that previously completed loading", ^{
            it(@"should succeed", ^{
                delegate stub_method("webView:shouldStartLoadWithRequest:navigationType:").and_return(YES);
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
    });

    describe(@"finishLoad", ^{
        describe(@"with no loading request", ^{
            beforeEach(^{
                expect(webView).to_not(be_loading());
            });

            it(@"should throw an exception", ^{
                ^{ [webView finishLoad]; } should raise_exception;
            });
        });

        describe(@"with a loading request", ^{
            beforeEach(^{
                delegate stub_method("webView:shouldStartLoadWithRequest:navigationType:").and_return(YES);
                [webView loadRequest:request];
                [webView finishLoad];
            });

            it(@"should send the webViewDidFinishLoad: message to the delegate", ^{
                delegate should have_received("webViewDidFinishLoad:").with(webView);
            });

            it(@"should mark the web view as no longer loading", ^{
                expect(webView).to_not(be_loading());
            });

            it(@"should maintain the loaded request", ^{
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

    describe(@"scalesPageToFit", ^{
        it(@"should not blow up", ^{
            [webView scalesPageToFit];
        });

        it(@"should return the truth", ^{
            [webView scalesPageToFit] should equal(NO);
            [webView setScalesPageToFit:YES];
            [webView scalesPageToFit] should equal(YES);
        });
    });

    describe(@"setScalesPageToFit:", ^{
        it(@"should not blow up", ^{
            [webView setScalesPageToFit:YES];
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

    describe(@"loadData:MIMEType:textEncodingName:baseURL:", ^{
        NSData *data = [@"some lovely data" dataUsingEncoding:NSUTF8StringEncoding];
        NSString *mimeType = @"text/plain";
        NSString *textEncodingName = @"UTF-POTATO";
        NSURL *baseURL = [NSURL URLWithString:@"cats"];

        beforeEach(^{
            [webView loadData:data MIMEType:mimeType textEncodingName:textEncodingName baseURL:baseURL];
        });

        it(@"should record the data", ^{
            expect(webView.loadedData).to(equal(data));
        });

        it(@"should record the MIME type", ^{
            expect(webView.loadedMIMEType).to(equal(mimeType));
        });

        it(@"should record the text encoding name", ^{
            expect(webView.loadedTextEncodingName).to(equal(textEncodingName));
        });

        it(@"should record the baseURL", ^{
            expect(webView.loadedBaseURL).to(equal(baseURL));
        });
    });

    describe(@"when loaded from a XIB", ^{
        beforeEach(^{
            AWebViewController *controller = [[AWebViewController alloc] initWithNibName:@"AWebViewController" bundle:nil];
            // Load the view.
            expect(controller.view).to_not(be_nil());
            webView = controller.webView;
            webView.delegate = delegate;
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
        });
    });
});

SPEC_END
