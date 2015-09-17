//
//  SettingsDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsDataSource.h"
#import "SettingsCell.h"
#import "UIFont+StatusLaneFonts.h"
#import "UIColor+StatusLane.h"
#import "Defaults.h"

@interface SettingsDataSource()

@property (nonatomic, strong) NSArray *myAccountSectionArray;
@property (nonatomic, strong) NSArray *moreInformationArray;
@property (nonatomic, strong) NSArray *accoutActionsArray;
@property (nonatomic, strong) NSArray *arrayOfPlaceholderText;


@end

@implementation SettingsDataSource


#pragma mark - internal methods

-(NSArray *)myAccountSectionArray{
    
    
    if (!_myAccountSectionArray) {
        
        NSAttributedString *fullName = [[NSAttributedString alloc]initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                           NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        NSAttributedString *username = [[NSAttributedString alloc]initWithString:@"Gender" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                          NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        NSAttributedString *email = [[NSAttributedString alloc]initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                    NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        _myAccountSectionArray = @[fullName,
                                   username,
                                   email];
        
    }
    
    return _myAccountSectionArray;
}

-(NSArray *)arrayOfPlaceholderText{
    
    
    if (!_arrayOfPlaceholderText) {
        
        NSAttributedString *fullNamePlaceHolder = [[NSAttributedString alloc]initWithString:@"Enter your name" attributes:@{NSForegroundColorAttributeName : [UIColor statusLaneGreen],
                                                                                                                                   NSFontAttributeName : [UIFont statusLaneAsapRegular:14]
                                                                                                                                    }];
        
        NSAttributedString *userNamePlaceHolder = [[NSAttributedString alloc]initWithString:@"Male/Female" attributes:@{NSForegroundColorAttributeName : [UIColor statusLaneGreen],
                                                                                                                                    NSFontAttributeName : [UIFont statusLaneAsapRegular:14]
                                                                                                                                    }];
        
        NSAttributedString *emailPlaceHolder = [[NSAttributedString alloc]initWithString:@"Enter your email address" attributes:@{NSForegroundColorAttributeName : [UIColor statusLaneGreen],
                                                                                                                                    NSFontAttributeName : [UIFont statusLaneAsapRegular:14]
                                                                                                                                    }];
        
        _arrayOfPlaceholderText = @[fullNamePlaceHolder,
                                    userNamePlaceHolder,
                                    emailPlaceHolder];
    }
    
    return _arrayOfPlaceholderText;
}

-(NSArray *)moreInformationArray{
    
    
    if (!_moreInformationArray) {
        
        NSAttributedString *support = [[NSAttributedString alloc]initWithString:@"Support" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                           NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        NSAttributedString *privacyPolicy = [[NSAttributedString alloc]initWithString:@"Privacy Policy" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                          NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        NSAttributedString *termsOfUse = [[NSAttributedString alloc]initWithString:@"Terms of Use" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                    NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        _moreInformationArray = @[support,
                                   privacyPolicy,
                                   termsOfUse];
    }
    
    return _moreInformationArray;
}

-(NSArray *)accoutActionsArray {
    
    if (!_accoutActionsArray) {
        
        NSAttributedString *logout = [[NSAttributedString alloc]initWithString:@"Logout" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                     NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        NSAttributedString *deleteAccout = [[NSAttributedString alloc]initWithString:@"Delete Account" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                NSFontAttributeName: [UIFont statusLaneAsapRegular:14]}];
        
        _accoutActionsArray = @[logout,
                                deleteAccout];
    }
    
    return _accoutActionsArray;
}
#pragma mark - SettingsDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfSections;
    if (section == 0 || section == 1) {
    
        numberOfSections = 3;
    }
    
    else if (section == 2){
        
        numberOfSections = 2;
    }
    
    
    return numberOfSections;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (indexPath.section == 0) {
        
        SettingsCell *cell = (SettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
        cell.label.attributedText = [self.myAccountSectionArray objectAtIndex:indexPath.row];
        cell.textField.attributedPlaceholder = [self.arrayOfPlaceholderText objectAtIndex:indexPath.row];
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = cell;
        
        if (indexPath.row == 0) {
            
            if ([Defaults fullName]) {
             
                cell.textField.text = [Defaults fullName];
                cell.textField.userInteractionEnabled = NO;
            }
            
            
        }
        
        else if (indexPath.row == 1){
         
            if ([Defaults sex]) {
                
                cell.textField.text = [Defaults sex];
                cell.textField.userInteractionEnabled = NO;
            }
            

        }
        
        else if (indexPath.row == 2){
            
            if ([Defaults emailAddress]) {
              
                cell.textField.text = [Defaults emailAddress];
            }
            

        }

        return cell;
        
    }
    
    else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell 2"];
        cell.textLabel.attributedText = [self.moreInformationArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    else  {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 2"];
        cell.textLabel.attributedText = [self.accoutActionsArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    
}









@end
