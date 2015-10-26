//
//  SearchUsers.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersPresenter.h"
#import "UIColor+StatusLane.h"
#import "SearchUsersInteractor.h"
#import "SWRevealViewController.h"
#import "UserProfilePresenter.h"
#import "StatusLaneErrorView.h"

@interface SearchUsersPresenter (){
    
    BOOL isUser;
}

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *anonymousUser;
@property (strong, nonatomic) SWRevealViewController *revealController;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation SearchUsersPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUIElements];
    [self interactor];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<SearchUsersInteractorDelegate>)interactor{
    
    if (!_interactor) {
        
        SearchUsersInteractor *interactor = [SearchUsersInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
        self.searchBar.delegate = _interactor;
    }
    
    return _interactor;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar resignFirstResponder];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"showUserProfile"]) {
        
        UserProfilePresenter *userProfilePresenter = segue.destinationViewController;
        if (isUser) {
            
            userProfilePresenter.user = self.user;
        }
        else{
            
            userProfilePresenter.user = self.anonymousUser;
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.interactor emptyDataSourceArray];
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}


#pragma mark - Search Users Presenter Delegate Methods
-(void)setFrontViewController{
    
    _revealController = self.revealViewController;
    [_revealController setFrontViewPosition:FrontViewPositionLeftSideMost animated:YES];
}

-(void)resetFrontViewController{
    
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}


#pragma mark - Presenter Delegate Methods

-(void)reloadData{
    
    [self.tableView reloadData];
}

-(void)showUserProfileForUser:(PFUser *)user{
    
    self.user = user;
    isUser = YES;
    [self performSegueWithIdentifier:@"showUserProfile" sender:self];
}

-(void)showUserProfileForAnonymousUser:(PFObject *)anonymousUser{
    
    self.anonymousUser = anonymousUser;
    isUser = NO;
    [self performSegueWithIdentifier:@"showUserProfile" sender:self];


}

-(void)dismissSearchBar{
    
    [self.searchBar resignFirstResponder];
}

-(void)startAnimating{
    
    [self.view addSubview:self.activityIndicator];
    [_activityIndicator startAnimating];
}

-(void)stopAnimating{
    
    [_activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
}

-(void)showResponseViewWithMessage:(NSString *)message andTitle:(NSString *)title{
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:message andTitle:title];
    [errorView showWithCompletionBlock:nil];
    
    
}

@end
