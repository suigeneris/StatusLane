//
//  ChooseContryDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 26/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CountryListDataSource.h"
#import "CountryListCell.h"


@interface CountryListDataSource()

@property (nonatomic, strong) NSArray *listOfCountries;
@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, strong) NSMutableArray *arrayWithNumberOfRows;
@property (nonatomic, strong) NSMutableArray *arrayOfCountrySections;

@end

@implementation CountryListDataSource

-(NSArray *)listOfCountries {
    
    if (!_listOfCountries) {
        
        
        NSError *error;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error
                            
                            ];
        
        _listOfCountries = [jsonDictionary objectForKey:@"countries"];
    }
    
    return _listOfCountries;
}

-(NSArray *)indexes{
    
    if (!_indexes) {
        
        _indexes = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                     @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"Y", @"Z"];
    }
    
    return _indexes;
    
}



-(NSMutableArray *)arrayWithNumberOfRows{
    
    if (!_arrayWithNumberOfRows) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.indexes.count; i++) {
            
            int  count = 0;
            NSString *string = [self.indexes objectAtIndex:i];
            
            for (NSDictionary *dict in self.listOfCountries){
                
                if ([[[dict objectForKey:@"name"] substringToIndex:1] isEqualToString:string]) {
                    
                    count++;
                }
                
            }
            [array addObject:[NSNumber numberWithInt:count]];

        }

        _arrayWithNumberOfRows = array;
    }
    
    return _arrayWithNumberOfRows;
}

-(NSMutableArray *)arrayOfCountrySections{
    
    if (!_arrayOfCountrySections) {
        
        NSMutableArray *countriesPerSection = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.indexes.count; i++) {
            
            NSString *string = [self.indexes objectAtIndex:i];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dict in self.listOfCountries) {
                
                if ([[[dict objectForKey:@"name"] substringToIndex:1] isEqualToString:string]) {
                    
                    [array addObject:dict];
                }
                else {
                    
                }
                
            }
            [countriesPerSection addObject:array];
        }
        
        _arrayOfCountrySections = countriesPerSection;
        
    }
    return _arrayOfCountrySections;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CountryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSMutableArray *array = [self.arrayOfCountrySections objectAtIndex:indexPath.section];
    
    cell.countryCodeLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"code"];
    cell.countryCodeLabel.textColor = [UIColor whiteColor];
    
    cell.countryNameLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.countryNameLabel.textColor = [UIColor whiteColor];
    
    return cell;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.indexes.count;
}
    

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSNumber *integer = [self.arrayWithNumberOfRows objectAtIndex:section];
    return [integer integerValue];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *titleForHeader = [self.indexes objectAtIndex:section];
    return titleForHeader;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexes;
}

@end














