//
//  ChoosePartnerDataSource.m
//  Status Lane
//
//  Created by Jonathan Aguele on 31/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ChoosePartnerDataSource.h"
#import "ChoosePartnerCellPresenter.h"
#import <AddressBook/AddressBook.h>

@interface ChoosePartnerDataSource()

@property (nonatomic, strong) NSArray *arrayOfContacts;
@property (nonatomic, strong) NSArray *arrayOfSections;

@end

@implementation ChoosePartnerDataSource


-(NSArray *)arrayOfContacts{
    
    if (!_arrayOfContacts) {
        
        _arrayOfContacts = [self retrieveContactsFromAddressBook];
    }
    return _arrayOfContacts;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayOfContacts.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoosePartnerCellPresenter *cell = (ChoosePartnerCellPresenter *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    cell.firstNameLabel.text = [_arrayOfContacts objectAtIndex:indexPath.row];
    return cell;
}


-(NSArray *)retrieveContactsFromAddressBook{
    
    
        CFErrorRef error = NULL;    
        NSArray *array = [[NSMutableArray alloc]init];
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        NSMutableArray *array2 = [[NSMutableArray alloc]init];
        if (addressBook != nil) {
            
            array = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
            for (int i = 0; i < [array count]; i++) {
                
                ABRecordRef contact = (__bridge ABRecordRef)[array objectAtIndex:i];
                NSString *string = (__bridge NSString *)(ABRecordCopyValue(contact, kABPersonFirstNameProperty));
                
                if (string) {
                    
                    [array2 addObject:string];
                    
                }
                
                else{
                    
                }
                
            }
            
            CFRelease(addressBook);
            
        }
        
        
        else{
            
        }
        
        NSArray *finalArray = [array2 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return finalArray;
}

















@end