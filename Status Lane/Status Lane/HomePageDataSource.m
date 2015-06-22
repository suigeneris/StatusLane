//
//  HomePageDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 13/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "HomePageDataSource.h"
#import "StatusListPresenterCell.h"
#import <UIKit/UIKit.h>
#import "UIFont+StatusLaneFonts.h"

@interface HomePageDataSource()

@property (nonatomic, strong) NSArray *arrayofStatusTypes;

@end

@implementation HomePageDataSource

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
    
    static NSString *CellIdentifier = @"Cell 1";

    StatusListPresenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"StatusListCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.statusTypeLabel.text = [self.arrayofStatusTypes objectAtIndex:indexPath.row];
    cell.statusTypeLabel.textColor = [UIColor blackColor];
    [cell.statusTypeLabel setFont:[UIFont statusLaneAsapRegular:15]];
    cell.tickImageView.image = [UIImage new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
    return cell;
}











@end
