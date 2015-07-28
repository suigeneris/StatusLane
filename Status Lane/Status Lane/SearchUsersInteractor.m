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
    [query whereKey:@"username" matchesRegex:details];
    [query includeKey:@"partner"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
        }
        
        else{
            
            if (array.count == 0) {
                
                //[self.searchResults addObjectsFromArray:array];
                [self searchForAnonymousUser:details];
            }
            
            else{
        
                [self.searchResults addObjectsFromArray:array];
                [self searchForAnonymousUser:details];

            }
        }
    
    
    }];
    
}

-(void)searchForAnonymousUser:(NSString *)details{
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
    [query whereKey:@"username" matchesRegex:details];
    [query includeKey:@"partner"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
        }
        
        else{
            
            if (array.count == 0) {
                
                [self.searchResults addObjectsFromArray:array];
                [self.presenter reloadData];
            }
            
            else{
                
                
                [self.searchResults addObjectsFromArray:array];
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
        
        [self searchForUserWithUserDetails:searchText];

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
