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

@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation SearchUsersDataSource


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SearchUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFUser *user = [self.searchResults objectAtIndex:indexPath.row];
    cell.phoneNumberLabel.text = user.username;
    cell.nameLabel.text = user[@"fullName"];
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
    cell.profileImageView.clipsToBounds = YES;
    cell.profileImageView.file = user[@"userProfilePicture"];
    [cell.profileImageView loadInBackground];
    return cell;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.searchResults = [self.interactor returnArrayOfSearchResults];
    return self.searchResults.count;
}


@end
