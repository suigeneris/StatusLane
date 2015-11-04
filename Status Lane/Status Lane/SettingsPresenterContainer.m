//
//  SettingsPresenterContainer.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsPresenterContainer.h"
#import "SWRevealViewController.h"
#import "StatusLaneErrorView.h"
#import "SettingsInteractor.h"
#import "Defaults.h"
#import "UIColor+StatusLane.h"

@interface SettingsPresenterContainer(){
    
    NSString  *currentEmail;
}

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SettingsPresenterContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    currentEmail = [Defaults emailAddress];
    SettingsInteractor *interactor = [SettingsInteractor new];
    interactor.presenter = self;
    self.interactor = interactor;

    [self setUpUIElements];
    [self revealControllerSetUp];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.interactor updateUserDetailsIfEmailChanged:currentEmail];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self.burgerMenuButton addTarget:self action:@selector(toggleBurgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.searchButton addTarget:self action:@selector(toggleSearch) forControlEvents:UIControlEventTouchUpInside];
        
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

#pragma mark - internal methods

-(void)toggleBurgerMenu{
    
    if ([Defaults fullName]
        && [Defaults emailAddress]
        && [Defaults sex]) {
        
        [self.revealViewController revealToggle:self];
        
    }
    
    else{
    
        StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:@"Please Complete The Form" color:[UIColor statusLaneRed] andTitle:@"OOOOPs!"];
        [errorView showWithCompletionBlock:nil];
    }
    
}

-(void)toggleSearch{
    
    if ([Defaults fullName]
        && [Defaults emailAddress]
        && [Defaults sex]) {
        
        [self.revealViewController rightRevealToggle:self];

    }
    
    else{
        
        StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:@"Please Complete The Form" color:[UIColor statusLaneRed] andTitle:@"OOOOPs!"];
        [errorView showWithCompletionBlock:nil];
    }
    
}



@end
