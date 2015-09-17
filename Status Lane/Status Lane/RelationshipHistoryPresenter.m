//
//  RelatioinshipHistoryPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelationshipHistoryPresenter.h"
#import "RelationshipHistoryInteractor.h"
#import "SWRevealViewController.h"
#import "UIColor+StatusLane.h"



@interface RelationshipHistoryPresenter()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation RelationshipHistoryPresenter


-(void)awakeFromNib{
    
    [super awakeFromNib];
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    [self revealControllerSetUp];
    [self.interactor retrieveStatusHistoryForUser];
}

-(id<UITableViewDelegate,RelationshipHistoryInteractorDatasource>)interactor{
    
    if (!_interactor) {
        RelationshipHistoryInteractor *interactor = [RelationshipHistoryInteractor new];
        interactor.presenter = self;
        self.interactor = interactor;
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

#pragma mark - IBActions

- (IBAction)burgerMenuButtonPressed:(id)sender {
    
}

- (IBAction)searchIconPressed:(id)sender {
}

#pragma mark - Presenter Delegate Methods

-(void)reloadDatasource{
    
    [self.tableView reloadData];
}

-(void)startAnimatingActivityView{
    
    [self.view addSubview:self.activityIndicator];
    [_activityIndicator startAnimating];
}

-(void)stopAnimatingActivitiyView{
    
    [_activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
}




@end



