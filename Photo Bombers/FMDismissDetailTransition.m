//
//  FMDismissDetailTransition.m
//  Photo Bombers
//
//  Created by Fredrick Myers on 3/26/14.
//  Copyright (c) 2014 Fredrick Myers. All rights reserved.
//

#import "FMDismissDetailTransition.h"

@implementation FMDismissDetailTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
