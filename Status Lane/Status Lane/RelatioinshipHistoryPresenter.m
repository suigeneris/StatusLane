//
//  RelatioinshipHistoryPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelatioinshipHistoryPresenter.h"
#import "RelationshipHistoryInteractor.h"

@interface RelatioinshipHistoryPresenter()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation RelatioinshipHistoryPresenter


-(void)awakeFromNib{
    
    [super awakeFromNib];
    RelationshipHistoryInteractor *interactor = [RelationshipHistoryInteractor new];
    self.interactor = interactor;
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
}

#pragma mark - IBActions

- (IBAction)burgerMenuButtonPressed:(id)sender {
}

- (IBAction)searchIconPressed:(id)sender {
}

@end
