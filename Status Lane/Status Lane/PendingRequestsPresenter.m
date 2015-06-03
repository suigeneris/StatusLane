//
//  PendingRequestsPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestsPresenter.h"
#import "PendingRequestInteractor.h"

@interface PendingRequestsPresenter()

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
@implementation PendingRequestsPresenter


-(void)awakeFromNib{
    
    [super awakeFromNib];
    PendingRequestInteractor *interactor = [PendingRequestInteractor new];
    self.interactor = interactor;
    
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpUIElements];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];
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
}
@end
