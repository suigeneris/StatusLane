//
//  PendingRequestsDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestsDataSource.h"
#import "PendingRequestCell.h"

@implementation PendingRequestsDataSource

#pragma mark - Data source methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{\
 
    
    return 2;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PendingRequestCell *cell = (PendingRequestCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    return cell;
}
@end
