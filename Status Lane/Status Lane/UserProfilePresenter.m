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
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *enlargedProfileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *partnerProfileImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@property (weak, nonatomic) IBOutlet UIButton *viewStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *cancellButton;

@property (weak, nonatomic) IBOutlet UILabel *searchUserStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertViewFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerName;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partnerProfileCenterXAlignment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageCenterXAlignment;

@property (strong, nonatomic) NSArray *arrayWithPartner;
@end

@implementation UserProfilePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self additionalUIViewSetup];
    //[self arrayWithPartner];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)arrayWithPartner{
    
    if (!_arrayWithPartner) {
        
        _arrayWithPartner = self.user[@"partner"];
    }
    
    return _arrayWithPartner;
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
    
    [self setUpImageViews];
    [self setImageForImageViews];
    
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
    self.searchUserStatusLabel.text = self.user[@"status"];
    self.fullNameLabel.text = self.user[@"fullName"];
    self.alertViewFullNameLabel.text = self.user[@"fullName"];
    
    
}

-(void)setUpImageViews{
    
    NSArray *imageViewArray = @[self.enlargedProfileImageView, self.profileImageView, self.partnerProfileImageView];
    
    for (PFImageView  *imageView in imageViewArray) {
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.clipsToBounds = YES;
    }
}

-(void)setImageForImageViews{
    
    NSArray *imageViewArray = @[self.enlargedProfileImageView, self.profileImageView];

    
        for (PFImageView *imageView in imageViewArray) {
            
            if (self.user[@"userProfilePicture"]) {

            imageView.file = self.user[@"userProfilePicture"];
            [imageView loadInBackground];
                
            }
            
            else{
                
                imageView.image = [UIImage imageNamed:@"Default_Profile_Image"];
            }
        }
    
    if ([[self.arrayWithPartner objectAtIndex:0] isKindOfClass:NSClassFromString(@"PFUser")]) {
        
        PFUser *user = [self.arrayWithPartner objectAtIndex:0];
        self.partnerName.text = user[@"fullName"];
        if (user[@"userProfilePicture"]) {
            
            self.partnerProfileImageView.file = user[@"userProfilePicture"];
        }
        
        else{
            
            self.partnerProfileImageView.image = [UIImage imageNamed:@"Default_Profile_Image"];

        }
    }
    
    else{
        
        PFObject *object = [self.arrayWithPartner objectAtIndex:0];
        self.partnerName.text = object[@"fullName"];

        if (object[@"userProfilePicture"]) {
            
            self.partnerProfileImageView.file = object[@"userProfilePicture"];
            [self.partnerProfileImageView loadInBackground];
        }
        
        else{
            
            self.partnerProfileImageView.image = [UIImage imageNamed:@"Default_Profile_Image"];
        }

    }
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
    
    if ([self.searchUserStatusLabel.text isEqualToString:@"SINGLE"]) {
                
        [UIView animateWithDuration:3
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                             self.searchUserStatusLabel.hidden = NO;

                             
                         } completion:nil];
        
        self.viewStatusButton.userInteractionEnabled = NO;
        [self.viewStatusButton setBackgroundColor:[UIColor statusLaneGreenPressed]];
    }
    
    else {
        
        self.profileImageCenterXAlignment.constant = 100;
        self.partnerProfileCenterXAlignment.constant = -100;
        
        [UIView animateWithDuration:0.36
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                             
                             
                         } completion:^(BOOL finished) {
                             
                             self.searchUserStatusLabel.hidden = NO;
                             self.partnerName.hidden = NO;
                             [self resetImageViewsPostition];
                             
                             
                         }];
        
        self.viewStatusButton.userInteractionEnabled = NO;
        [self.viewStatusButton setBackgroundColor:[UIColor statusLaneGreenPressed]];
        
    }

    
    


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
                         
                         self.viewStatusButton.userInteractionEnabled = YES;
                         [self.viewStatusButton setBackgroundColor:[UIColor statusLaneGreen]];
                         self.searchUserStatusLabel.hidden = YES;
                         self.partnerName.hidden = YES;
                     }];
    
    
}

-(void)crossDissolveBackgroundImage{
    
    PFFile  *file = self.user[@"userBackgroundPicture"];
    if (file) {
        
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            
            [_activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            if (error) {
                
                NSLog(@"Error fetching data");
                
            }
            
            else{
                
                if (data) {
                    
                
                    UIImage *image = [UIImage imageWithData:data];
                    self.backgroundImageView.alpha = 1;
                    self.backgroundImageView.image = image;
                                         
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


























