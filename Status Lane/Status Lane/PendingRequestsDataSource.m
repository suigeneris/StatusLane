//
//  PendingRequestsDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestsDataSource.h"
#import "PendingRequestCell.h"
#import "NSString+StatusLane.h"
#import "NetworkManager.h"

@interface PendingRequestsDataSource()


@property(nonatomic, strong) NSArray *arrayOfNotifications;
@property(nonatomic, strong) NSArray *arrayOfPFUsers;
@property(nonatomic, strong) id <NetworkProvider> networkProvider;
@property(nonatomic, strong) PFFile *imageFile;

@end

@implementation PendingRequestsDataSource



-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager alloc];
    }
    return _networkProvider;
}
#pragma mark - Data source methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    self.arrayOfNotifications = [self.interactor returnArrayOfNotifications];
    return self.arrayOfNotifications.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.arrayOfPFUsers.count == 0) {
        
        self.arrayOfPFUsers = [self.interactor returnArrayOfNotificationSenders];

    }
    
    PendingRequestCell *cell = (PendingRequestCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    NSMutableDictionary *dict = [_arrayOfNotifications objectAtIndex:indexPath.row];
    cell.usernameLabel.text = [dict objectForKey:@"senderFullName"];
    cell.descriptionLabel.text = [dict objectForKey:@"alert"];
    
        for (PFUser *user in self.arrayOfPFUsers) {
            
            if ([[user objectId] isEqualToString:[dict objectForKey:@"senderObjectId"]]) {
                
                if (user[@"userProfilePicture"]) {
                    
                    [dict setObject:user[@"userProfilePicture"] forKey:@"profilePicFile"];

                }
                else{
                    
                    [dict setObject:[UIImage imageNamed:@"Default_Profile_Image"] forKey:@"profilePicFile"];
                }
            }
        }
    
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
    cell.profileImageView.clipsToBounds = YES;
    
    if ([[dict objectForKey:@"profilePicFile"] isKindOfClass:NSClassFromString(@"PFFile")]) {
        
        cell.profileImageView.file = [dict objectForKey:@"profilePicFile"];
        [cell.profileImageView loadInBackground];

    }
    
    else{
        
        cell.profileImageView.image = [dict objectForKey:@"profilePicFile"];

    }

    
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




@end





