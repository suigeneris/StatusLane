//
//  SearchUsersInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersInteractor.h"

@implementation SearchUsersInteractor


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    [self.presenter resetFrontViewController];
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.presenter setFrontViewController];

}
@end
