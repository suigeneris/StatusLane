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
#import "NetworkManager.h"
#import "Defaults.h"

@interface SettingsInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) SettingsDataSource *settingsDataSource;
@property (nonatomic, strong) id <NetworkProvider> networkProvider;


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

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [PFUser logOut];
            [self.presenter logOut];
        }
        
        else{
            
            [self.presenter showAlertView];
            
        }

    }
    
}

-(void)updateUserDetailsIfEmailChanged:(NSString *)email{
    
    PFUser *currentUser = [PFUser currentUser];
    if (![email isEqualToString:[Defaults emailAddress]]) {
        
        currentUser[@"fullName"] = [Defaults fullName];
        currentUser[@"gender"] = [Defaults sex];
        currentUser.email = [Defaults emailAddress];
        [currentUser saveInBackground];
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

#pragma mark - Interactor Delegate
-(void)deleteUserAccount{
    
    PFUser *currentUser = [PFUser currentUser];
    [self.networkProvider deleteUserAccountWithAccount:currentUser
                                               success:^(id responseObject) {
                                                   
                                                   [PFUser logOut];
                                                   [self.presenter logOut];
                                                   
                                               } failure:^(NSError *error) {
                                                   
                                                   NSLog(@"This is the error %@", error.localizedDescription);
                                                   
                                               }];
}


@end
