//
//  SearchUsersDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SearchUsersDataSource.h"
#import "SearchUsersCell.h"
#import <Parse/Parse.h>

@interface SearchUsersDataSource()

@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SearchUsersDataSource

-(NSMutableArray *)searchResults{
    
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc]init];
    }
    return _searchResults;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SearchUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([[self.searchResults objectAtIndex:indexPath.row] isKindOfClass:NSClassFromString(@"PFUser")]) {
        
        PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
        cell.phoneNumberLabel.text = user.username;
        cell.nameLabel.text = user[@"fullName"];
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = YES;
        cell.profileImageView.file = user[@"userProfilePicture"];
        [cell.profileImageView loadInBackground];
        if (user[@"userProfilePicture"]) {
            cell.profileImageView.file = user[@"userProfilePicture"];
            [cell.profileImageView loadInBackground];
        }
        else{
            
            cell.profileImageView.image = [UIImage imageNamed:@"Default_Profile_Image"];
            
        }
        return cell;
    }
    
    else{
        
        PFObject *user = [self.searchResults objectAtIndex:indexPath.row];
        cell.phoneNumberLabel.text = user[@"username"];
        cell.nameLabel.text = user[@"fullName"];
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = YES;
        
        if (user[@"userProfilePicture"]) {
            cell.profileImageView.file = user[@"userProfilePicture"];
            [cell.profileImageView loadInBackground];
        }
        else{
            
            cell.profileImageView.image = [UIImage imageNamed:@"Default_Profile_Image"];

        }
        return cell;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.searchResults = [self.interactor returnArrayOfSearchResults];
    return self.searchResults.count;
}


@end
