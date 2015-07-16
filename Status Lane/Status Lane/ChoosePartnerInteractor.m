//
//  ChoosePartnerInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ChoosePartnerInteractor.h"
#import "CountryCode.h"
#import "ChoosePartnerDataSource.h"
#import "ChoosePartnerPresenter.h"
#import "ChoosePartnerCellPresenter.h"
#import "AddressBookContact.h"
#import <AddressBook/AddressBook.h>
#import "UIColor+StatusLane.h"
#import <Parse/Parse.h>


@interface ChoosePartnerInteractor(){
    
    int currentExpandedIndex;

}

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) ChoosePartnerDataSource *choosePartnerDataSource;
@property (nonatomic, strong) NSArray *arrayOfContacts;
@property (nonatomic, strong) NSMutableArray *arrayOfContactNumbers;
@property (nonatomic, strong) NSArray *searchResults;


@end


@implementation ChoosePartnerInteractor



#pragma mark ChoosePartnerInteractor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;

}

-(void)passArrayOfContacts:(NSArray *)contacts withNumbers:(NSMutableArray *)numbers{
    
    self.arrayOfContacts = contacts;
    self.arrayOfContactNumbers = numbers;

}
-(NSArray *)returnSearchResults{
    
    return  self.searchResults;
}

-(void)askUserForPermissionToViewContacts{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        [self.presenter showAlertWithTitle:@"May we have your permisson" errorMessage:@"We would like to access your contacts if thats ok with you" andActionTitle:@"OK"];
        
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        [self.presenter reloadData];

    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                if (!granted){
                    
                    [self.presenter showAlertWithTitle:@"May we have your permisson" errorMessage:@"We would like to access your contacts if thats ok with you" andActionTitle:@"OK"];
                    
                    return;
                }
                
                else{
                    
                    [self.presenter reloadData];
                
                }
            
        });
            
        
            
        });
    }
    
}

-(void)openSettings{
    
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:appSettings];
}

-(void)updateUserPartnerWithFullName:(NSString *)fullName andNumber:(NSString *)number{
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoosePartnerCellPresenter *cell = (ChoosePartnerCellPresenter *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *string = [self.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
    
    [self.presenter dismissTabelViewWithPartnerName:string andNumber:cell.contactNumber.text];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 20)];
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

-(void)saveStatusToDefaults:(NSString *)status{
    
    [Defaults setStatus:status];
    
}




#pragma mark ChoosePartnerInteractor DataSource

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = self.choosePartnerDataSource;
    }

    return _dataSource;
}


-(ChoosePartnerDataSource *)choosePartnerDataSource{
    
    if (!_choosePartnerDataSource) {
        
        _choosePartnerDataSource = [ChoosePartnerDataSource new];
        _choosePartnerDataSource.interactor = self;
        
    }
    
    return _choosePartnerDataSource;
}



#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.presenter dismissSearchBar];
    
}

#pragma mark UISearchBar Delegate

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [self searchForContactsMatchingText:@""];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqual: @""]) {
        
        self.searchResults = [NSArray new];
        [self.presenter reloadData];
    }
    else{
        
        [self searchForContactsMatchingText:searchText];
        
    }
    
}

#pragma mark - Internal Methods

-(void)searchForContactsMatchingText:(NSString *)searchText{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (AddressBookContact *abc in self.arrayOfContacts) {
        
        if ([[abc.contactName uppercaseString] containsString:[searchText uppercaseString]]) {
            
            [array addObject:abc];
        }

    }
    self.searchResults = array;
    [self.presenter reloadData];
}

-(NSString *)replaceCharactersIsString:(NSString *)string{
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
    string = [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    return string;
    
}








@end
