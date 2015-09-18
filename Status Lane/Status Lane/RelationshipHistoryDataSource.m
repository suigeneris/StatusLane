//
//  RelationshipHistoryDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelationshipHistoryDataSource.h"
#import "RelationshipHistoryCellPresenter.h"
#import "NetworkManager.h"
#import "Defaults.h"


@interface RelationshipHistoryDataSource()

@property(nonatomic, strong) NSArray *arrayOfStatusHistoryObjects;
@property(nonatomic, strong) NSMutableArray *arrayOfPFUsers;


@end

@implementation RelationshipHistoryDataSource

-(NSMutableArray *)arrayOfPFUsers{
    
    if (!_arrayOfPFUsers) {
        _arrayOfPFUsers = [NSMutableArray new];
    }
    return _arrayOfPFUsers;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.arrayOfStatusHistoryObjects = [self.interactor returnArrayOfHistoryObjects];
    return self.arrayOfStatusHistoryObjects.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.arrayOfPFUsers.count == 0) {
        
        self.arrayOfPFUsers = [self.interactor returnArrayOfUsersInStatusHistory];
       
    }
    
    RelationshipHistoryCellPresenter *cell = (RelationshipHistoryCellPresenter *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    if (self.arrayOfStatusHistoryObjects) {
        
        NSMutableDictionary *dict = [self.arrayOfStatusHistoryObjects objectAtIndex:indexPath.row];
        
        cell.fullNameLabel.text = [dict objectForKey:@"partnerName"];
        cell.userStatusLabel.text = [dict objectForKey:@"statusType"];
        
        if ([[dict objectForKey:@"statusEndDate"] isKindOfClass:NSClassFromString(@"NSString" )]) {
            
            NSString *startDate = [self returnStringFromDate:[dict objectForKey:@"statusDate"]];
            
            NSString *endDate = @"Till Date";
            
            cell.userStatusDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
            
            cell.statusDuration.text = [self returnStatusDurationWithStartDate:[dict objectForKey:@"statusDate"] andEndDate:nil];
            
        }
        else{
            
            NSString *startDate = [self returnStringFromDate:[dict objectForKey:@"statusDate"]];
            
            NSString *endDate = [self returnStringFromDate:[dict objectForKey:@"statusEndDate"]];
            
            cell.userStatusDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
            
            cell.statusDuration.text = [self returnStatusDurationWithStartDate:[dict objectForKey:@"statusDate"] andEndDate:[dict objectForKey:@"statusEndDate"]];
            
        }
        
        for (PFObject *object in self.arrayOfPFUsers) {
            
            if ([object.objectId isEqualToString:[dict objectForKey:@"partnerId"]]) {

                if (object[@"userProfilePicture"]) {
                    
                    [dict setObject:object[@"userProfilePicture"] forKey:@"profilePicFile"];
                    
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
    }
    return cell;
}

-(NSString *)returnStatusDurationWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate{

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    
    NSDateComponents *difference = [gregorian components:units fromDate:startDate toDate:endDate ? endDate : [NSDate date] options:0];
    
    NSInteger years = [difference year];
    NSInteger month = [difference month];

    NSString *intervalBetweenDates;
    
    if (years > 1) {
        
        if (month > 1) {
            
            intervalBetweenDates = [NSString stringWithFormat:@"%ld Years, %ld Months", (long)years, (long)month];

        }
        
        else{
            
            intervalBetweenDates = [NSString stringWithFormat:@"%ld Years, %ld Month", (long)years, (long)month];

        }
    }
    
    else{
        
        if (month > 1) {
            
            intervalBetweenDates = [NSString stringWithFormat:@"%ld Months",(long)month];
            
        }
        
        else{
            
            intervalBetweenDates = @"Less Than A Month";
            
        }
    }
    
    return intervalBetweenDates;
}


-(NSString *)returnStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    NSString *startDate = [formatter stringFromDate:date];
    return startDate;
    
}


@end








