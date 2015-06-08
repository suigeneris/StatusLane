//
//  SettingsPresenterContainer.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsPresenterContainer.h"
#import "SWRevealViewController.h"
@interface SettingsPresenterContainer()

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SettingsPresenterContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUIElements];
    [self revealControllerSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Additional UI Setup

- (void)setUpUIElements {
    
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
        [self.burgerMenuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
        [self.searchButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - Settings Presenter Delegate

-(void)logOut:(UIViewController *)viewController{
    
    [self.navigationController popToViewController:viewController animated:YES];
}
@end
