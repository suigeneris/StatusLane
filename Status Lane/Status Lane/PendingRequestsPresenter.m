//
//  PendingRequestsPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestsPresenter.h"
#import "PendingRequestInteractor.h"
#import "SWRevealViewController.h"
#import "UIColor+StatusLane.h"


@interface PendingRequestsPresenter()

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenu;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;



@end
@implementation PendingRequestsPresenter



-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpUIElements];
    [self interactor];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];
    [self revealControllerSetUp];
    [self.interactor retrieveArrayOfNotificationsForUser];
}

-(id<UITableViewDelegate,PendingRequestsInteractorDataSource,PendingRequestsInteractor>)interactor{
    
    if (!_interactor) {
        
        PendingRequestInteractor *interactor = [PendingRequestInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
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


#pragma mark - Internal Methods



-(void)revealControllerSetUp{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.burgerMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        [self.searchButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}



-(void)setUpUIElements{
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3
                                           ];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}



- (IBAction)burgerMenuPressed:(id)sender {
    NSLog(@"Burger menu pressed");
}

- (IBAction)xButtonPressed:(id)sender {

    UIButton *butn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:butn];
    if (cell != nil) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.interactor rejectNotificationForUserAtIndexPath:indexPath];
    }
    
}
- (IBAction)acceptButtonPressed:(id)sender {
    
    UIButton *butn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:butn];
    if (cell != nil) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.interactor acceptNotificationForUserAtIndexPath:indexPath];
    }
}


-(UITableViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
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

-(void)deleteTableViewRowWithIndexPaths:(NSIndexPath *)indexPath{
    
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.tableView beginUpdates];
    //[self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
@end













