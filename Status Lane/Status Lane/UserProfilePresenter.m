//
//  UserProfilePresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "UserProfilePresenter.h"

@interface UserProfilePresenter ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UIButton *viewStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *cancellButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *enlargedProfileImageView;

@end

@implementation UserProfilePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self additionalUIViewSetup];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)additionalUIViewSetup{
    
    self.viewStatusButton.layer.cornerRadius = 1.6;
    self.sendButton.layer.cornerRadius = 1.6;
    self.cancellButton.layer.cornerRadius = 1.6;
    
    self.enlargedProfileImageView.layer.borderWidth = 2;
    self.enlargedProfileImageView.layer.cornerRadius = self.enlargedProfileImageView.frame.size.width/2;
    self.enlargedProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.profileImageView.layer.borderWidth = 2;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;



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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backkButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewStatusButtonPressed:(id)sender {
    
    self.popUpView.hidden = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         self.popUpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
;
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
                         [self.viewStatusButton setTitle:@"MARRIED" forState:UIControlStateNormal];

                     }];

}


@end


























