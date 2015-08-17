//
//  CountryListInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 26/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CountryListInteractor.h"
#import "CountryListDataSource.h"
#import "UIColor+StatusLane.h"
#import "CountryListCell.h"
#import "CountryCode.h"

@interface CountryListInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) CountryListDataSource *countryListDataSource;

@end

@implementation CountryListInteractor

-(id<UITableViewDataSource>)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = self.countryListDataSource;
    }
    
    return _dataSource;
}


-(CountryListDataSource *)countryListDataSource {
    
    if (!_countryListDataSource) {
        
        _countryListDataSource = [CountryListDataSource new];
    }
    
    return _countryListDataSource;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CountryListCell *cell = (CountryListCell *)[tableView cellForRowAtIndexPath:indexPath];
    CountryCode *code = [CountryCode sharedInstance];
    code.countryCode = cell.countryCodeLabel.text;
    [self.presenter dismissView];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    headerTitleLabel.text = [self.dataSource tableView:tableView titleForHeaderInSection:section];
    headerTitleLabel.textColor = [UIColor statusLaneGreen];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    headerView.backgroundColor = [UIColor blackColor];
    [headerView addSubview:headerTitleLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}
@end
