//
//  UserProfilePresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "UserProfilePresenter.h"
#import "UIColor+StatusLane.h"
#import "UIImage+StatusLane.h"
#import <ParseUI/ParseUI.h>

@interface UserProfilePresenter ()

@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UIButton *viewStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *cancellButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *enlargedProfileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *partnerProfileImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partnerProfileCenterXAlignment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageCenterXAlignment;
@end

@implementation UserProfilePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self additionalUIViewSetup];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //[self crossDissolveBackgroundImage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIActivityIndicatorView *)activityIndicator{
    
    if (!_activityIndicator) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.center = self.view.center;
        _activityIndicator.color = [UIColor statusLaneGreenPressed];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.tag = 1111;
    }
    return _activityIndicator;
}

-(void)additionalUIViewSetup{
    
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self crossDissolveBackgroundImage];
    
    self.viewStatusButton.layer.cornerRadius = 1.6;
    self.sendButton.layer.cornerRadius = 1.6;
    self.cancellButton.layer.cornerRadius = 1.6;
    
    self.enlargedProfileImageView.layer.borderWidth = 2;
    self.enlargedProfileImageView.layer.cornerRadius = self.enlargedProfileImageView.frame.size.width/2;
    self.enlargedProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.enlargedProfileImageView.clipsToBounds = YES;

    self.enlargedProfileImageView.file = self.user[@"userProfilePicture"];
    [self.enlargedProfileImageView loadInBackground];
    
    
    self.profileImageView.layer.borderWidth = 2;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;

    self.profileImageView.file = self.user[@"userProfilePicture"];
    [self.profileImageView loadInBackground];


    self.partnerProfileImageView.layer.borderWidth = 2;
    self.partnerProfileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.partnerProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.partnerProfileImageView.file = self.user[@"userProfilePicture"];
    self.partnerProfileImageView.clipsToBounds = YES;

    [self.partnerProfileImageView loadInBackground];
    
    [self.bottomUIView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    NSLayoutConstraint *buttomUIViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomUIView
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                   multiplier:0.30
                                                                                     constant:0
                                                        ];
    [self.view addConstraint:buttomUIViewHeightConstraint];
    
    self.popUpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    
    
}

- (IBAction)backkButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.backgroundImageView.image = [UIImage imageNamed:@"Background"];

}

- (IBAction)viewStatusButtonPressed:(id)sender {
    
    self.popUpView.hidden = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         self.popUpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];

                     }];
    
    
}
- (IBAction)cancelButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         self.popUpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                         self.popUpView.hidden = YES;

                     }];

    
}
- (IBAction)sendButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         self.popUpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                         self.popUpView.hidden = YES;
                         [self animateViews];

                     }];


}

-(void)animateViews{
    
    [[self.view viewWithTag:111] removeFromSuperview];
    self.profileImageCenterXAlignment.constant = 100;
    self.partnerProfileCenterXAlignment.constant = -100;
    
    [UIView animateWithDuration:0.36
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                         
                     }];
    
    [UIView animateWithDuration:0.36
                     animations:^{
                         
                         [self.view layoutIfNeeded];

                         
                     } completion:^(BOOL finished) {
                         
                         [self resetImageViewsPostition];
                         
                     }];
}

-(void)resetImageViewsPostition{
    
    self.profileImageCenterXAlignment.constant = 0;
    self.partnerProfileCenterXAlignment.constant = 0;

    
    [UIView animateWithDuration:0.36
                          delay:3
                        options:0
                     animations:^{
                         
                         [self.view layoutIfNeeded];

                     } completion:^(BOOL finished) {
                         
                         
                     }];
    
    
}

-(void)crossDissolveBackgroundImage{
    
    PFFile  *file = self.user[@"userBackgroundPicture"];
    if (file) {
        
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            
            [_activityIndicator stopAnimating];
            if (error) {
                
                NSLog(@"Error fetching data");
                
            }
            
            else{
                
                if (data) {
                    
                
                    UIImage *image = [UIImage imageWithData:data];
                    self.backgroundImageView.alpha = 1;
                    self.backgroundImageView.image = image;
                                         
                }
                
                else{
                    
                }
                
            }
            
            
        }];
        
        [self.view addSubview:self.activityIndicator];
        [_activityIndicator startAnimating];
    }
    
    else{
        
        
    }
    

}
@end


























