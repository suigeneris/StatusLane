//
//  StatusListAnimationController.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SLTransitionAnimator.h"
#import "HomePagePresenter.h"
#import "StatusListPresenter.h"

@interface SLTransitionAnimator()


@property (nonatomic) UIViewController *parentViewController;
@property (nonatomic) UIViewController *presentedViewController;

@end

@implementation SLTransitionAnimator

-(BOOL)isPresenting{
    
    if (!_isPresenting) {
        self.isPresenting = _isPresenting;
    }
    
    return _isPresenting;
}


-(id)initWithParentViewController:(UIViewController *)viewController presentedViewController:(UIViewController *)presentedViewController{
    if (!(self = [super init])) return nil;
    
    _parentViewController = viewController;
    _presentedViewController = presentedViewController;
    
    return self;
}



-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.35;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.isPresenting) {
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]);
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame.origin.y += CGRectGetWidth([[transitionContext containerView] bounds]);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    

}
















@end
