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
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewStatusButtonPressed:(id)sender {
    
    NSLog(@"button pressed");
}


@end
