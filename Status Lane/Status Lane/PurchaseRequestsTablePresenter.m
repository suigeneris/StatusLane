//
//  PurchaseRequestsTablePresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PurchaseRequestsTablePresenter.h"
#import "PurchaseRequestsInteractor.h"
#import "PurchseRequestPresenterCell.h"


@implementation PurchaseRequestsTablePresenter


-(void)viewDidLoad{
    
    [super viewDidLoad];
    NSLog(@"Row selected");


    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PurchseRequestPresenterCell *cell = (PurchseRequestPresenterCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    if (indexPath.row == 0) {
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"1 Status Request";
        cell.priceLabel.text = @"£0.99";
    }
    
    else if (indexPath.row ==1){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"3 Status Requests";
        cell.priceLabel.text = @"£1.99";
        
    }
    
    else if (indexPath.row == 2){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"5 Status Requests";
        cell.priceLabel.text = @"£3.99";
        
    }
    
    else if (indexPath.row ==3){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"Unlimited";
        cell.priceLabel.text = @"£9.99";
        
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
@end
