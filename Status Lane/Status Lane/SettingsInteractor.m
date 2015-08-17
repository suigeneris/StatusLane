//
//  SettingsInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsInteractor.h"
#import "SettingsDataSource.h"
#import "UIColor+StatusLane.h"
#import "UIFont+StatusLaneFonts.h"
#import <Parse/Parse.h>

@interface SettingsInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) SettingsDataSource *settingsDataSource;

@end

@implementation SettingsInteractor

-(id<UITableViewDataSource>)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = self.settingsDataSource;
    }
    
    return _dataSource;
}


-(SettingsDataSource *)settingsDataSource {
    
    if (!_settingsDataSource) {
        
        _settingsDataSource = [SettingsDataSource new];
    }
    
    return _settingsDataSource;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        [PFUser logOut];
        [self.presenter logOut];
    }
    
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 7.5, tableView.bounds.size.width, 20)];
    viewLabel.textColor = [UIColor statusLaneGreen];
    viewLabel.font = [UIFont statusLaneAsapBold:11];
    
    if (section == 0) {
        
        viewLabel.text = NSLocalizedString(@"MY ACCOUNT", @"MY ACCOUNT");
    }
    
    else if (section == 1) {
        
        viewLabel.text = NSLocalizedString(@"MORE INFORMATION", @"MORE INFORMATION");
    }
    
    else if (section == 2) {
        
        viewLabel.text = NSLocalizedString(@"ACCOUNT ACTIONS", @"ACCOUNT ACTIONS");
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [headerView addSubview:viewLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}
@end
