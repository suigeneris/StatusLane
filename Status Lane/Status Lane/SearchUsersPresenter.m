//
//  SearchUsers.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersPresenter.h"
#import "UIColor+StatusLane.h"

@interface SearchUsersPresenter ()
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation SearchUsersPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUIElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Additional UI Setup 

- (void)setUpUIElements {
    
    [self customiseSearchBar];
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3
                                           ];

}

-(void)customiseSearchBar {
    
    UITextField *textfield = [self.searchBar valueForKey:@"_searchField"];
    textfield.textColor = [UIColor whiteColor];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil]setTextColor:[UIColor statusLaneGreen]];

    [textfield setBackgroundColor:[UIColor colorWithRed:1
                                                  green:1
                                                   blue:1
                                                  alpha:0.03
                                   ]];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    
    self.searchBar.tintColor = [UIColor colorWithRed:1
                                               green:1
                                                blue:1
                                               alpha:1
                                ];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
