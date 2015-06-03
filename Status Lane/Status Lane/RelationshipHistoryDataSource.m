//
//  RelationshipHistoryDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelationshipHistoryDataSource.h"
#import "RelationshipHistoryCellPresenter.h"

@implementation RelationshipHistoryDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RelationshipHistoryCellPresenter *cell = (RelationshipHistoryCellPresenter *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    
    
    return cell;
}

@end
