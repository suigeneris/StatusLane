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
    cell.descriptionLabel.adjustsFontSizeToFitWidth = YES;
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

    bool re = [[dict objectForKey:@"needsResponse"] boolValue];
    
    if (re) {
        cell.okButton.hidden = YES;
        cell.xbutton.hidden = NO;
        cell.tickButton.hidden = NO;
        cell.disclosureArrow.hidden = YES;
        cell.disclosureArrow2.hidden = YES;


    }
    else if ([cell.descriptionLabel.text isEqualToString:@"Approved Your Status Request"]){
        
        cell.okButton.hidden = YES;
        cell.xbutton.hidden = YES;
        cell.tickButton.hidden = YES;
        cell.disclosureArrow.transform = CGAffineTransformMakeRotation(-M_PI); //rotation in radians
        cell.disclosureArrow.hidden = NO;
        cell.disclosureArrow2.hidden = YES;
        cell.disclosureArrow2.userInteractionEnabled = NO;
        NSLog(@"%@", cell.descriptionLabel.text);


    }
    else if ([cell.descriptionLabel.text isEqualToString:@"Approved Your Status History Request"]){
        
        cell.okButton.hidden = YES;
        cell.xbutton.hidden = YES;
        cell.tickButton.hidden = YES;
        cell.disclosureArrow.userInteractionEnabled = NO;
        cell.disclosureArrow.hidden = YES;
        cell.disclosureArrow2.transform = CGAffineTransformMakeRotation(-M_PI); //rotation in radians
        cell.disclosureArrow2.hidden = NO;

    }
    else {
        
        cell.okButton.hidden = NO;
        cell.xbutton.hidden = YES;
        cell.tickButton.hidden = YES;
        cell.disclosureArrow.hidden = YES;
        cell.disclosureArrow2.hidden = YES;


    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




@end





