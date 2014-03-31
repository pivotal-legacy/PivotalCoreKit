#if !__has_feature(objc_arc)
#error "ARC is required for this file"
#endif

#import "UIView+PCKNibHelpers.h"


@implementation NSLayoutConstraint (PCKNibHelpers)

- (NSLayoutConstraint *)constraintByReplacingView:(UIView *)viewToReplace withView:(UIView *)replacingView {
    UIView *firstItem = self.firstItem;
    UIView *secondItem = self.secondItem;

    if (self.firstItem == viewToReplace) {
        firstItem = replacingView;
    } else if (self.secondItem == viewToReplace) {
        secondItem = replacingView;
    }

    return [NSLayoutConstraint constraintWithItem:firstItem
                                        attribute:self.firstAttribute
                                        relatedBy:self.relation
                                           toItem:secondItem
                                        attribute:self.secondAttribute
                                       multiplier:self.multiplier
                                         constant:self.constant];
}

@end

@implementation UIView (PCKNibHelpers)

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    UINib *classNib = nil;
    if ([self.restorationIdentifier hasPrefix:@"placeholder"] && (classNib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil])) {
        UIView *nibInstance = [[classNib instantiateWithOwner:nil options:nil] firstObject];
        nibInstance.translatesAutoresizingMaskIntoConstraints = NO;

        for (NSLayoutConstraint *constraint in self.constraints) {
            [nibInstance addConstraint:[constraint constraintByReplacingView:self withView:nibInstance]];
        }

        for (NSLayoutConstraint *constraint in self.superview.constraints) {
            [self.superview addConstraint:[constraint constraintByReplacingView:self withView:nibInstance]];
        }

        return nibInstance;
    }

    return self;
}

@end
