#import "Cedar.h"
#import "UIPageControl+Spec.h"
#import "Target.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIPageControl_SpecSpec)

describe(@"UIPageControlSpec", ^{
    __block UIPageControl *pageControl;
    __block Target *target;
    __block UIView *view;

    beforeEach(^{
        pageControl = [[UIPageControl alloc] init];
        target = [[Target alloc] init];
        
        [pageControl addTarget:target
                        action:@selector(hello)
              forControlEvents:UIControlEventValueChanged];
        
        view = [[UIView alloc] init];
        [view addSubview:pageControl];
    });

    describe(@"handling exceptions", ^{
        context(@"when control is hidden", ^{
            beforeEach(^{
                pageControl.hidden = YES;
            });
            
            it(@"should raise an exception", ^{
                ^{
                    [pageControl tapLeft];
                } should raise_exception.with_reason(@"Can't tap an invisible control");
            });
        });
        
        context(@"when control is disabled", ^{
            beforeEach(^{
                pageControl.enabled = NO;
            });
            
            it(@"should raise an exception", ^{
                ^{
                    [pageControl tapRight];
                } should raise_exception.with_reason(@"Can't tap a disabled control");
            });
        });
        
        context(@"when control is has no width", ^{
            beforeEach(^{
                pageControl.frame = CGRectMake(0, 0, 0, 50);
            });
            
            it(@"should raise an exception", ^{
                ^{
                    [pageControl tapLeft];
                } should raise_exception.with_reason(@"Can't tap a control with no width or height. Your control may not be laid out correctly.");
            });
        });
        
        context(@"when control is has no width", ^{
            beforeEach(^{
                pageControl.frame = CGRectMake(0, 0, 50, 0);
            });
            
            it(@"should raise an exception", ^{
                ^{
                    [pageControl tapRight];
                } should raise_exception.with_reason(@"Can't tap a control with no width or height. Your control may not be laid out correctly.");
            });
        });
    });
    
    describe(@"tapping actions", ^{
        beforeEach(^{
            pageControl.frame = CGRectMake(0, 0, 50, 50);
            pageControl.numberOfPages = 3;
            
            spy_on(target);
        });
        
        afterEach(^{
            stop_spying_on(target);
        });
        
        context(@"tapping right", ^{
            it(@"should increment current page and trigger UIControlEventValueChanged", ^{
                [pageControl tapRight];
                
                pageControl.currentPage should be_greater_than(0);
                target should have_received(@selector(hello));
            });
        });
        
        context(@"tapping left", ^{
            beforeEach(^{
                pageControl.currentPage = 1;
            });
            
            it(@"should increment current page and trigger UIControlEventValueChanged", ^{
                [pageControl tapLeft];
                
                pageControl.currentPage should equal(0);
                target should have_received(@selector(hello));
            });
        });
    });
});

SPEC_END
