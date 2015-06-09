//
//  StatusListInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusListInteractor.h"
#import "StatusListPresenterCell.h"
#import "StatusListDataSource.h"
#import "UIFont+StatusLaneFonts.h"
#import "UIColor+StatusLane.h"

@interface StatusListInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) StatusListDataSource *statusListDataSource;

@end

@implementation StatusListInteractor

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        _dataSource = self.statusListDataSource;
        
    }
    
    return _dataSource;
}

-(StatusListDataSource *)statusListDataSource{
    
    if (!_statusListDataSource) {
        
        _statusListDataSource = [StatusListDataSource new];
    }
    
    return _statusListDataSource;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView reloadData];
    StatusListPresenterCell *cell = (StatusListPresenterCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.statusTypeLabel setFont:[UIFont statusLaneAsapBold:15]];
    cell.statusTypeLabel.textColor = [UIColor statusLaneGreen];
    cell.tickImageView.image = [UIImage imageNamed:@"Tick"];
    
    
}
@end
