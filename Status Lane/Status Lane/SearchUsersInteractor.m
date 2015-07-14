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
@property (nonatomic, strong) NSArray *searchResults;


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


#pragma mark - Internal Methods

-(void)searchForUserWithUserDetails:(NSString *)details{
    
    PFQuery *query = [PFUser query];
    query.limit = 20;
    [query whereKey:@"username" matchesRegex:details];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
        }
        
        else{
            
            if (array.count == 0) {
                
                self.searchResults = array;
                [self.presenter reloadData];
            }
            
            else{
                
                
                self.searchResults = array;
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
        
    }
    else{
        
        [self searchForUserWithUserDetails:searchText];

    }

}

#pragma mark - UITableViewDelegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *selectedUser = [self.searchResults objectAtIndex:indexPath.row];
    [self.presenter showUserProfileForUser:selectedUser];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.presenter dismissSearchBar];
    
}


#pragma mark - Interactor Delegate Methods

-(NSArray *)returnArrayOfSearchResults{
    
    return self.searchResults;
}

-(void)emptyDataSourceArray{
    
    NSArray *emptyArray = [NSArray new];
    self.searchResults = emptyArray;
    [self.presenter reloadData];
    
}

@end
