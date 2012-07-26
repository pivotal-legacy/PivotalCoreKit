#import <UIKit/UIKit.h>

#import "ComparatorsBase.h"

namespace Cedar { namespace Matchers { namespace Comparators {
    template<typename U>
    bool compare_equal(CGRect const actualValue, const U & expectedValue) {
        return CGRectEqualToRect(actualValue, expectedValue);
    }

    template<typename U>
    bool compare_equal(CGSize const actualValue, const U & expectedValue) {
        return CGSizeEqualToSize(actualValue, expectedValue);
    }

    template<typename U>
    bool compare_equal(CGPoint const actualValue, const U & expectedValue) {
        return CGPointEqualToPoint(actualValue, expectedValue);
    }

    template<typename U>
    bool compare_equal(UIEdgeInsets const actualValue, const U & expectedValue) {
        return UIEdgeInsetsEqualToEdgeInsets(actualValue, expectedValue);
    }

    template<typename U>
    bool compare_equal(CGAffineTransform const actualValue, const U & expectedValue) {
        return CGAffineTransformEqualToTransform(actualValue, expectedValue);
    }
}}}

#import <sstream>
#import "StringifiersBase.h"

namespace Cedar { namespace Matchers { namespace Stringifiers {
    inline NSString * string_for(const CGRect value) {
        return NSStringFromCGRect(value);
    }

    inline NSString * string_for(const CGSize value) {
        return NSStringFromCGSize(value);
    }

    inline NSString * string_for(const CGPoint value) {
        return NSStringFromCGPoint(value);
    }

    inline NSString * string_for(const UIEdgeInsets value) {
        return NSStringFromUIEdgeInsets(value);
    }

    inline NSString * string_for(const CGAffineTransform value) {
        return NSStringFromCGAffineTransform(value);
    }
}}}
