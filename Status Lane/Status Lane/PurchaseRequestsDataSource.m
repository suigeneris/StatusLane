//
//  PurchaseRequestsDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PurchaseRequestsDataSource.h"
#import "PurchseRequestPresenterCell.h"

@implementation PurchaseRequestsDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  4;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PurchseRequestPresenterCell *cell = (PurchseRequestPresenterCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    if (indexPath.row == 0) {
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];

        cell.numberOfRequestsLabel.text = @"10 Status Request";
        cell.priceLabel.text = @"£0.99";
    }
    
    else if (indexPath.row ==1){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"30 Status Requests";
        cell.priceLabel.text = @"£1.99";
        
    }
    
    else if (indexPath.row == 2){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"50 Status Requests";
        cell.priceLabel.text = @"£3.99";
        
    }
    
    else if (indexPath.row ==3){
        
        [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Unchecked"] forState:UIControlStateNormal];
        cell.numberOfRequestsLabel.text = @"Unlimited";
        cell.priceLabel.text = @"£9.99";
        
    }
    return cell;
}
@end
