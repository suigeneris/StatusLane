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

@end

@implementation RelationshipHistoryDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.arrayOfStatusHistoryObjects = [self.interactor returnArrayOfHistoryObjects];
    return self.arrayOfStatusHistoryObjects.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        }
        else{
            
            cell.userStatusDate.text = [NSString stringWithFormat:@"%@ - Till Date", startDate];
        }

    }
    
    return cell;
}

@end
