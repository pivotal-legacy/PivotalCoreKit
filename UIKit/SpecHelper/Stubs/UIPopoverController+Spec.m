//
//  UIPopoverController+Spec.m
//  UIKit
//
//  Created by pivotal on 3/4/14.
//  Copyright (c) 2014 Pivotal Labs. All rights reserved.
//

#import "UIPopoverController+Spec.h"

@implementation UIPopoverController (Spec)

static UIPopoverController *popoverController;

+ (instancetype)currentPopoverController {
    return popoverController;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

// -presentPopoverFromBarButtonItem:permittedArrowDirections:animated: calls through to this method
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
    popoverController = self;
}

#pragma clang diagnostic pop 

@end
