//
//  StatusListAnimationController.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusListAnimationController.h"
#import "HomePagePresenter.h"
#import "StatusListPresenter.h"

@interface StatusListAnimationController()

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation StatusListAnimationController

-(BOOL)isPresenting{
    
    if (!_isPresenting) {
        self.isPresenting = _isPresenting;
    }
    
    return _isPresenting;
}

-(NSTimeInterval)duration{
    
    if (_duration) {
        
        _duration = 0.5;
    }
    
    return _duration;
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return self.duration;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    

}
















@end
