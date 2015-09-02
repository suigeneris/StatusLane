//
//  SettingsCell.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsCell.h"
#import "StatusLaneErrorView.h"
#import "NSString+StatusLane.h"
#import "Defaults.h"
#import "AppDelegate.h"

@interface SettingsCell() {
    
    BOOL dismissKeyboard;
}

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;

@end

@implementation SettingsCell


#pragma mark - TextField Delegate Methods

-(void)awakeFromNib{
    
    [super awakeFromNib];
    

}


//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    
//    if (textField.tag == 0) {
//        
//        if ([self validateFullName:textField.text]) {
//            [Defaults setFullName:textField.text];
//        }
//        else{
//            
//            [self showErrorViewWithMessage:@"Please Enter a valid username :)" withResignTextField:textField];
//        }
//        
//    }
//    
//    else if (textField.tag == 1){
//        
//        if ([self validateGender:textField.text]) {
//            [Defaults setSex:textField.text];
//            
//        }
//        else{
//            
//            [self showErrorViewWithMessage:@"Please Enter either Male or Female :)" withResignTextField:textField];
//        }
//        
//    }
//    
//    if (textField.tag == 2) {
//        
//        if ([textField.text isValidEmail]) {
//            [Defaults setEmailAddress:textField.text];
//            self.fullName = textField.text;
//            
//        }
//        else{
//            
//            [self showErrorViewWithMessage:@"Please Enter a valid email :)" withResignTextField:textField];
//        }
//        
//    }
//    
//}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    BOOL final;
    
    if (textField.tag == 0) {
        
        if ([self validateFullName:textField.text]) {
            [Defaults setFullName:textField.text];
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter a valid name :)" withResignTextField:textField];
            final =  NO;
        }
        
    }
    
    else if (textField.tag == 1) {
        
        if ([self validateGender:textField.text]) {
            [Defaults setSex:textField.text];
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter either Male or Female :)" withResignTextField:textField];
            final =  NO;
        }
        
    }
    else if (textField.tag == 2) {
        
        if ([textField.text isValidEmail]) {
            [Defaults setEmailAddress:textField.text];
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter a valid email :)" withResignTextField:textField];
            final =  NO;
        }

    }

    return final;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    if ([Defaults fullName]
        && [Defaults emailAddress]
        && [Defaults sex]) {
        
        NSLog(@"Return");
        [textField resignFirstResponder];
        return YES;
    }
    
    else{
        
        [self showErrorViewWithMessage:@"Please Complete the form :)" withResignTextField:textField];
        return NO;

    }
    
}

-(BOOL)validateFullName:(NSString *)username{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    set = [set invertedSet];

    NSRange range = [username rangeOfCharacterFromSet:set];

    if (range.location != NSNotFound || [username isEqualToString:@""]) {
        return NO;
    }
    
    else {
        return YES;
        
    }
}

-(BOOL)validateGender:(NSString *)gender{
    
    if ([gender caseInsensitiveCompare:@"male"] == NSOrderedSame || [gender caseInsensitiveCompare:@"female"] == NSOrderedSame) {
        return YES;
    }
    else{
        return NO;

        
    }
}

-(void)showErrorViewWithMessage:(NSString *)message withResignTextField:(UITextField *)textField {
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc] initWithMessage:message];
    
    [errorView show];
    
}



@end









