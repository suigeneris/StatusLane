//
//  StatusListPresention.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusListPresention.h"
#import <UIKit/UIKit.h>

@interface StatusListPresention()

@property (nonatomic,strong) UIView *dimView;

@end

@implementation StatusListPresention


-(UIView *)dimView{
    
    if (!_dimView) {
        
        _dimView = [[UIView alloc]initWithFrame:CGRectMake(self.containerView.bounds.origin.x, self.containerView.bounds.origin.y, self.containerView.bounds.size.width, self.containerView.bounds.origin.y)];
        _dimView.backgroundColor = [UIColor clearColor];
        _dimView.alpha = 0.0;
    }
    
    return _dimView;
}
- (void)presentationTransitionWillBegin{
    
    self.dimView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.dimView];
    [self.containerView addSubview:self.presentedView];
    
    
}


-(void)presentationTransitionDidEnd:(BOOL)completed{
    
    if (!completed) {
        [self.dimView removeFromSuperview];
    }
}

-(void)dismissalTransitionWillBegin{
    
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.dimView.alpha = 0.0;
        
    } completion:nil];
    
    
}

-(void)dismissalTransitionDidEnd:(BOOL)completed{
    
    if (completed) {
        [self.dimView removeFromSuperview];
    }
}


-(CGRect)frameOfPresentedViewInContainerView{
    
    CGRect frame = self.containerView.bounds;
    frame = CGRectInset(frame, 50.0, 50.0);
    return frame;
    
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.dimView.frame = self.containerView.bounds;
    } completion:nil];
}











@end
