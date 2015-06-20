//
//  PurchaseRequestsInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 07/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PurchaseRequestsInteractor.h"
#import "PurchseRequestPresenterCell.h"
#import "PurchaseRequestsDataSource.h"


@interface PurchaseRequestsInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) PurchaseRequestsDataSource *purchaseRequestsDataSource;


@end

@implementation PurchaseRequestsInteractor



#pragma mark PurchaseRequests DataSource

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = self.purchaseRequestsDataSource;
    }
    
    return _dataSource;
}

-(PurchaseRequestsDataSource *)purchaseRequestsDataSource{
    
    if (!_purchaseRequestsDataSource) {
        
        _purchaseRequestsDataSource = [PurchaseRequestsDataSource new];
        
    }
    
    return _purchaseRequestsDataSource;
}


#pragma mark PurchaseRequests Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView reloadData];
    PurchseRequestPresenterCell *cell = (PurchseRequestPresenterCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.seletedButton setImage:[UIImage imageNamed:@"Purchase Checked"] forState:UIControlStateNormal];
}


@end
