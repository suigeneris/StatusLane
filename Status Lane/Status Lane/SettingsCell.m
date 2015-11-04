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
#import "NetworkManager.h"
#import "UIColor+StatusLane.h"

@interface SettingsCell() {
    
    BOOL dismissKeyboard;
}

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) id<NetworkProvider> networkProvider;

@end

@implementation SettingsCell


#pragma mark - TextField Delegate Methods


-(void)awakeFromNib{
    
    [super awakeFromNib];
    

}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [[NetworkManager alloc]init];
    }
    
    return _networkProvider;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    BOOL final;
    
    if (textField.tag == 0) {
        
        if ([self validateFullName:textField.text]) {
            self.fullName = textField.text;
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter a valid name :)" withResignTextField:textField];
            final =  NO;
        }
        
    }
    
    else if (textField.tag == 1) {
        
        if ([self validateGender:textField.text]) {
            self.gender = textField.text;
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter either Male or Female :)" withResignTextField:textField];
            final =  NO;
        }
        
    }
    else if (textField.tag == 2) {
        
        if ([textField.text isValidEmail]) {
            self.email = textField.text;
            final = YES;
            
        }
        else{
            
            [self showErrorViewWithMessage:@"Please Enter a valid email :)" withResignTextField:textField];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailAddress"];

            final =  NO;
        }

    }

    return final;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    BOOL returnTextfeild;
    
    if (textField.tag == 0) {
        
        id view = [textField superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        
        UITableView *tableView = (UITableView *)view;
        SettingsCell *cell = (SettingsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UIResponder *nextResponder = cell.textField;
        
        if (nextResponder) {
            
            [nextResponder becomeFirstResponder];
        }
        returnTextfeild = NO;
        
    }
    
    else if (textField.tag == 1) {
        
        id view = [textField superview];
        
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        
        UITableView *tableView = (UITableView *)view;
        SettingsCell *cell = (SettingsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UIResponder *nextResponder = cell.textField;
        
        if (nextResponder) {
            
            [nextResponder becomeFirstResponder];
        }
        returnTextfeild = NO;
        
    }
    
    else if (textField.tag == 2) {
        
        id view = [textField superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        
        UITableView *tableView = (UITableView *)view;
        SettingsCell *cell1 = (SettingsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        SettingsCell *cell2 = (SettingsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        SettingsCell *cell3 = (SettingsCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

        
        if (cell1.textField.text && cell2.textField.text) {
            
            [Defaults setFullName:cell1.textField.text];
            [Defaults setSex:cell2.textField.text];
            [Defaults setEmailAddress:cell3.textField.text];
            
            [textField resignFirstResponder];
            returnTextfeild =  YES;
        }
        
        else{
            
            [self showErrorViewWithMessage:@"Please Complete the form :)" withResignTextField:textField];
            returnTextfeild =  NO;
            
        }
    }
    
    
    return returnTextfeild;
}

-(BOOL)validateFullName:(NSString *)username{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ "];
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
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc] initWithMessage:message color:[UIColor redColor] andTitle:@"OOOOPs!"];
    
    if (app.window.subviews.count < 2) {
        
        [errorView showWithCompletionBlock:nil];

    }
}




@end









