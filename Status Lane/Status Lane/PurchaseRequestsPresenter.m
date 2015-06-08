//
//  PurchaseRequestsPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PurchaseRequestsPresenter.h"
#import "UIColor+StatusLane.h"
#import "SWRevealViewController.h"
#import "PurchaseRequestsInteractor.h"

@interface PurchaseRequestsPresenter ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundVIew;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation PurchaseRequestsPresenter

-(void)awakeFromNib{
    
    PurchaseRequestsInteractor *interactor = [PurchaseRequestsInteractor new];
    interactor.presenter = self;
    self.interactor = interactor;
}

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

-(void)setUpUIElements {
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3];
    self.containerView.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.3];
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
- (IBAction)burgerMneuButtonPressed:(id)sender {
}

@end
