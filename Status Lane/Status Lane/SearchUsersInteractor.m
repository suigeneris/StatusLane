//
//  SearchUsersInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersInteractor.h"
#import "SearchUsersDataSource.h"

@interface SearchUsersInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) SearchUsersDataSource *searchUsersDatasource;


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
    }
    
    return _searchUsersDatasource;
}

#pragma mark UISearchBar Delegate

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    //[self.presenter resetFrontViewController];
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.presenter setFrontViewController];

}


@end
