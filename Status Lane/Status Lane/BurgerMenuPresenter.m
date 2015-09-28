//
//  BurgerMenuPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "BurgerMenuPresenter.h"
#import "UIColor+StatusLane.h"
#import "BurgerMenuInteractor.h"
#import "SWRevealViewController.h"


@interface BurgerMenuPresenter()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *relaionshipHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseRequestsButton;
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
@property (weak, nonatomic) IBOutlet UIButton *referAfriendButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIImageView *unseenRequestImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) SWRevealViewController *revealController;

@end

@implementation BurgerMenuPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpUIElements];
    [self setRightSideViewCOntroller];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setUpProfileImage];
}
-(id<BurgerMenuInteractor>)interactor{
    
    if (!_interactor) {
        
        BurgerMenuInteractor *interactor = [BurgerMenuInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    }
    return _interactor;
}



-(void)setUpUIElements{
    
    //[self.buttonContainerView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    self.unseenRequestImageView.layer.cornerRadius = self.unseenRequestImageView.bounds.size.width/2;
    
    // show image
    
    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // create vibrancy effect
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    // add blur to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add vibrancy to yet another effect view
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    effectView.frame = self.view.frame;
    
    // add both effect views to the image view
    [self.backgroundImage addSubview:effectView];
    [self.backgroundImage addSubview:vibrantView];
    
    [self.homeButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    [self.relaionshipHistoryButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    [self.requestsButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchaseRequestsButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    [self.referAfriendButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(setText:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Internal methods


-(void)setText:(UIButton *)pressedButton{
    
    [self resetAllButtonsToWhite];
    [pressedButton setTitleColor:[UIColor statusLaneGreen] forState:UIControlStateNormal];
}


-(void)resetAllButtonsToWhite{
    
    [self.relaionshipHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.purchaseRequestsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.requestsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.referAfriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)setUpProfileImage{
    
    
    self.profileImageView.image = [self.interactor retrieveProfileImageFromFile];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 2;
    self.profileImageView.clipsToBounds = YES;
}


-(void)setRightSideViewCOntroller{
    
    _revealController = self.revealViewController;
    [_revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
}

@end










