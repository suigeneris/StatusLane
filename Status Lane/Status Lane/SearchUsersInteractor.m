//
//  SearchUsersInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersInteractor.h"
#import "SearchUsersDataSource.h"
#import "SearchedUser.h"
#import "NSString+StatusLane.h"
#import <Parse/Parse.h>

@interface SearchUsersInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) SearchUsersDataSource *searchUsersDatasource;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation SearchUsersInteractor


-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = self.searchUsersDatasource;
        
    }
    
    return _dataSource;
}

-(SearchUsersDataSource *)searchUsersDatasource{
    
    if (!_searchUsersDatasource) {
        
        _searchUsersDatasource = [SearchUsersDataSource new];
        _searchUsersDatasource.interactor = self;
    }
    
    return _searchUsersDatasource;
}

-(NSMutableArray *)searchResults{
    
    if (!_searchResults) {
        
        _searchResults = [[NSMutableArray alloc]init];
        
    }
    return _searchResults;
}


#pragma mark - Internal Methods

-(void)searchForUserWithUserDetails:(NSString *)details{
    
    [self.searchResults removeAllObjects];
    PFQuery *query = [PFUser query];

    if ([details rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
        
        [query whereKey:@"username" matchesRegex:details];
        [query includeKey:@"partner"];
        query.limit = 20;

    }
    
    else{
        
        [query whereKey:@"fullName" containsString:[NSString uppercaseAllFirstCharactersOfString:details]];
        [query includeKey:@"partner"];
        query.limit = 20;

    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            if (error.code == 154) {
                
                [self.presenter startAnimating];
                [query cancel];
            }
            else{
                
                [self.presenter stopAnimating];
                [self.presenter showResponseViewWithMessage:error.localizedDescription
                                                   andTitle:@"OOOOPs!"];
            }
            
        }
        
        else{
            
            if (array.count == 0) {
                
                [self searchForAnonymousUser:details];
            }
            
            else{
                
                if (array.count != 0) {
                    
                    for (id object in array) {
                        
                        if (![self.searchResults containsObject:object]) {
                            
                            [self.searchResults addObject:object];
                            
                        }
                    }
                    
                }
                [self searchForAnonymousUser:details];

            }
        }
    
    
    }];
    
    [self.presenter startAnimating];
    
}

-(void)searchForAnonymousUser:(NSString *)details{
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
    if ([details rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
        
        [query whereKey:@"username" matchesRegex:details];
        [query includeKey:@"User.partner"];
        query.limit = 20;
        
    }
    
    else{
        
        [query whereKey:@"fullName" containsString:[NSString uppercaseAllFirstCharactersOfString:details]];
        [query includeKey:@"User.partner"];
        query.limit = 20;
        
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            if (error.code == 154) {
                [self.presenter startAnimating];
                [query cancel];
           
            }
            else{
                
                [self.presenter stopAnimating];
                [self.presenter showResponseViewWithMessage:error.localizedDescription
                                                   andTitle:@"OOOOPs!"];

            }
        }
        
        else{
            
            if (array.count == 0) {
                
                [self.presenter stopAnimating];
                [self.searchResults addObjectsFromArray:array];
                [self.presenter reloadData];
            }
            
            else{
                
                [self.presenter stopAnimating];
                if (array.count != 0) {
                    
                    for (id object in array) {
                        
                        if (![self.searchResults containsObject:object]) {
                            
                            [self.searchResults addObject:object];
                            
                        }
                    }
                    
                }
                //[self.searchResults addObjectsFromArray:array];
                [self.presenter reloadData];
                
            }
        }
        
        
    }];
    
}

-(void)parseSeachResultsFromArray:(NSArray *)array{
    
    NSMutableArray *arrayOfPFUsers = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        
 
    }
    
    self.searchResults = [arrayOfPFUsers copy];
}

#pragma mark UISearchBar Delegate

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.presenter setFrontViewController];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText  isEqual: @""]) {
        
        [self.searchResults removeAllObjects];
        [self.presenter reloadData];
    }
    else{
        
        CGFloat mod = fmod(searchText.length, 2);
        if (mod == 0 || searchText.length == 1) {
            
            [self searchForUserWithUserDetails:searchText];

        }

    }

}

#pragma mark - UITableViewDelegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.searchResults objectAtIndex:indexPath.row] isKindOfClass:NSClassFromString(@"PFUser")]) {
        
        PFUser *selectedUser = [self.searchResults objectAtIndex:indexPath.row];
        [self.presenter showUserProfileForUser:selectedUser];

    }
    
    else{
        
        PFObject *selectedObject = [self.searchResults objectAtIndex:indexPath.row];
        [self.presenter showUserProfileForAnonymousUser:selectedObject];
    }
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.presenter dismissSearchBar];
    
}


#pragma mark - Interactor Delegate Methods

-(NSMutableArray *)returnArrayOfSearchResults{
    
    return self.searchResults;
}

-(void)emptyDataSourceArray{
    
    [self.searchResults removeAllObjects];
    [self.presenter reloadData];
    
}

@end
