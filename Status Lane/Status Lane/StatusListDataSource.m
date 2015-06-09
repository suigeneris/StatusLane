//
//  StatusListDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusListDataSource.h"
#import "StatusListPresenterCell.h"
#import <UIKit/UIKit.h>
#import "UIFont+StatusLaneFonts.h"


@interface StatusListDataSource()

@property (nonatomic, strong) NSArray *arrayofStatusTypes;

@end

@implementation StatusListDataSource

-(NSArray *)arrayofStatusTypes{
    
    if (!_arrayofStatusTypes) {
        
        _arrayofStatusTypes = @[@"SINGLE", @"MARRIED", @"DATING", @"RELATIONSHIP", @"SEEING", @"COMPLICATED", @"ENGAGED"];
    }
    
    return _arrayofStatusTypes;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.arrayofStatusTypes.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    StatusListPresenterCell *cell = (StatusListPresenterCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    cell.statusTypeLabel.text = [self.arrayofStatusTypes objectAtIndex:indexPath.row];
    cell.statusTypeLabel.textColor = [UIColor blackColor];
    [cell.statusTypeLabel setFont:[UIFont statusLaneAsapRegular:15]];
    cell.tickImageView.image = [UIImage new];
    return cell;
}

@end
