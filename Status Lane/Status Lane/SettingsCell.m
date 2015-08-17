//
//  SettingsCell.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell


#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 0) {
        
        [self validateUserName:textField.text];

    }
    
    else if(textField.tag == 2){
        
        [self validateEmail:textField.text];
    }
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)validateUserName:(NSString *)username{
    
    
    return YES;
}

-(BOOL)validateEmail:(NSString *)email{
    
    
    return YES;
}

@end
