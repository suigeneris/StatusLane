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
    
        PFObject *object = [self.arrayOfStatusHistoryObjects objectAtIndex:indexPath.row];
        if (object[@"partnerName"]) {
            
            cell.fullNameLabel.text = object[@"partnerName"];
        }
        else{
            
            cell.fullNameLabel.text = @"";
        }
        cell.userStatusLabel.text = object[@"statusType"];
        
        NSDate *date = object[@"statusDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        NSString *startDate = [formatter stringFromDate:date];

        if (object[@"statusEndDate"]) {
         
            NSDate *date2 = object[@"statusEndDate"];
            NSString *endDate = [formatter stringFromDate:date2];
            cell.userStatusDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
            cell.statusDuration.text = [self returnStatusDurationWithStartDate:date andEndDate:date2];
        }
        else{
            
            cell.userStatusDate.text = [NSString stringWithFormat:@"%@ - Till Date", startDate];
            cell.statusDuration.text = [self returnStatusDurationWithStartDate:date andEndDate:nil];

        }
        
        for (PFObject *object in self.arrayOfPFUsers){
            
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



@end








