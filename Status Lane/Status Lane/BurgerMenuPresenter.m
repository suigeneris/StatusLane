//
//  BurgerMenuPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "BurgerMenuPresenter.h"

@interface BurgerMenuPresenter()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *relaionshipHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseRequestsButton;
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
@property (weak, nonatomic) IBOutlet UIButton *referAfriendButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIImageView *unseenRequestImageView;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


@end
@implementation BurgerMenuPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpUIElements];
}

-(void)setUpUIElements{
    
    [self.buttonContainerView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    self.unseenRequestImageView.layer.cornerRadius = self.unseenRequestImageView.bounds.size.width/2;

}





@end
