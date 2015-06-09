//
//  StatusListAnimationController.h
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SLTransitionAnimator : NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresenting;

-(id)initWithParentViewController:(UIViewController *)viewController presentedViewController:(UIViewController *)presentedViewController;

@end
