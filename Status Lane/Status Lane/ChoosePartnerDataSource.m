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
#import "AddressBookContact.h"

@interface ChoosePartnerDataSource()

@property (nonatomic, strong) NSArray *arrayOfContacts;
@property (nonatomic, strong) NSMutableArray *arrayOfContactNumbers;
@property (nonatomic, strong) NSMutableArray *indexes;
@property (nonatomic, strong) NSArray *searchResultsFromInteractor;

@end

@implementation ChoosePartnerDataSource


-(NSArray *)arrayOfContacts{
    
    if (!_arrayOfContacts) {
        
            _arrayOfContacts = [self retrieveContactsFromAddressBook];
        
    }
    return _arrayOfContacts;
}

-(NSArray *)arrayOfContactNumbers{
    
    if (!_arrayOfContactNumbers) {
        
        _arrayOfContactNumbers = [NSMutableArray new];
        for (AddressBookContact *abc in self.arrayOfContacts) {
            
            [_arrayOfContactNumbers addObject:abc.arrayOfContacts];
            
            [self.interactor passArrayOfContacts:self.arrayOfContacts withNumbers:_arrayOfContactNumbers];
            
        }
    }
    return _arrayOfContactNumbers;
}

-(NSArray *)searchResultsFromInteractor{
    
    if(!_searchResultsFromInteractor){
        
        _searchResultsFromInteractor = [[NSArray alloc]init];
    }
    return _searchResultsFromInteractor;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchResultsFromInteractor.count == 0) {
        
        NSArray *array =  [self.arrayOfContactNumbers objectAtIndex:section];
        return array.count;
    }
    else{
        
        AddressBookContact *abc =  [self.searchResultsFromInteractor objectAtIndex:section];
        
        return abc.arrayOfContacts.count;
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [self upDateSearchResults];
    if (self.searchResultsFromInteractor.count == 0) {
        
        return self.arrayOfContacts.count;

    }
    
    else{
        
        return self.searchResultsFromInteractor.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoosePartnerCellPresenter *cell = (ChoosePartnerCellPresenter *)[tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    
    if (self.searchResultsFromInteractor.count == 0) {
        
        AddressBookContact *addressBookContact = [self.arrayOfContacts objectAtIndex:indexPath.section];
        NSArray *array = addressBookContact.arrayOfContacts;
        
        cell.contactNumber.text = [array objectAtIndex:indexPath.row];
        cell.firstNameLabel.text = addressBookContact.contactName;
        return cell;
    }
    
    else{
        
        AddressBookContact *addressBookContact = [self.searchResultsFromInteractor objectAtIndex:indexPath.section];
        NSArray *array = addressBookContact.arrayOfContacts;
        
        cell.contactNumber.text = [array objectAtIndex:indexPath.row];
        cell.firstNameLabel.text = addressBookContact.contactName;
        return cell;
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.searchResultsFromInteractor.count == 0) {
       
        AddressBookContact *addressbookContact = [self.arrayOfContacts objectAtIndex:section];
        NSString *titleForHeader = addressbookContact.contactName;
        return titleForHeader;
    }
    else{
        
        AddressBookContact *addressbookContact = [self.searchResultsFromInteractor objectAtIndex:section];
        NSString *titleForHeader = addressbookContact.contactName;
        return titleForHeader;
    }

    
}


-(NSArray *)retrieveContactsFromAddressBook{
    
        CFErrorRef error = NULL;    
        NSArray *array = [[NSMutableArray alloc]init];
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        NSMutableArray *array2 = [[NSMutableArray alloc]init];
        if (addressBook != nil) {
            
            array = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
            for (int i = 0; i < [array count]; i++) {
                
                AddressBookContact *addressBookContact = [AddressBookContact new];
                ABRecordRef contact = (__bridge ABRecordRef)[array objectAtIndex:i];
                ABMultiValueRef phoneNumbers = ABRecordCopyValue(contact, kABPersonPhoneProperty);

                addressBookContact.contactName = (__bridge NSString *)(ABRecordCopyValue(contact, kABPersonFirstNameProperty));
                
                if (addressBookContact.contactName) {
                    
                    addressBookContact.arrayOfContacts = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumbers);
                    
                    if (addressBookContact.arrayOfContacts) {
                        
                        [array2 addObject:addressBookContact];

                    }
                    else{
                        
                    }
                    
                }
                
                else{
                    
                }
                
            }
            
            CFRelease(addressBook);
            
        }
        
        
        else{
            
        }
    
        NSArray *finalArray = [array2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSString *first = [(AddressBookContact *)obj1 contactName];
            NSString *second = [(AddressBookContact *)obj2 contactName];
            return [first compare:second];


        }];

    return finalArray;
}


-(void)upDateSearchResults{
    
    self.searchResultsFromInteractor = [self.interactor returnSearchResults];
}














@end