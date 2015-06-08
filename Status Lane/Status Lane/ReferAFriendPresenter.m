//
//  ReferAFriendPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ReferAFriendPresenter.h"
#import "SWRevealViewController.h"

@interface ReferAFriendPresenter()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenu;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;



@end
@implementation ReferAFriendPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUPUIElements];
    [self revealControllerSetUp];
    
}

-(void)setUPUIElements{
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3
                                           ];
}

-(void)revealControllerSetUp{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.burgerMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
        [self.searchButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
