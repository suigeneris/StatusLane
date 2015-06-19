//
//  CreateAccountPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CreateAccountPresenter.h"
#import "CreateAccountInteractor.h"
#import "UIColor+StatusLane.h"
//#import "NBPhoneNumberUtil"

@interface CreateAccountPresenter () <UITextFieldDelegate>
    
@property (weak, nonatomic) IBOutlet UILabel *statusLaneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@end

@implementation CreateAccountPresenter
    


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setAttributesForUILabel];
    
   
}

-(void)viewWillAppear:(BOOL)animated{

    [self countryCodeButton];
    
}

-(id<CreateAccountInteractor>)interactor{
    
    if (!_interactor) {
        
        _interactor = [CreateAccountInteractor new];
    }
    
    return _interactor;
    
}

-(UIButton *)countryCodeButton{

    if (_countryCodeButton) {
        
        NSString *string = [self.interactor requestCountryCode];

        if (string == (id)[NSNull null] || string.length == 0 ) {

            [_countryCodeButton setTitle:@"+44" forState:UIControlStateNormal];
        }
        
        else{

            [_countryCodeButton setTitle:string forState:UIControlStateNormal];
        }
    }
    
    return _countryCodeButton;
}
#pragma mark - Additional UI setup

- (void)setAttributesForUILabel {
    

    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:self.statusLaneLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 6)];
    self.statusLaneLabel.attributedText = attrStr;
    

    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"mobile number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.countryCodeButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    
    self.passwordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.passwordTextField.delegate = self;
    self.phoneNumberTextfield.delegate = self;
}

- (IBAction)continueButtonPressed:(id)sender {
    
    [self.interactor phoneNumberChanged:self.phoneNumberTextfield.text];
    [self.interactor passwordChanged:self.passwordTextField.text];
    [self.interactor countryCodeChanged:self.countryCodeButton.titleLabel.text];
    [self.interactor attemptRegisterUser];
}

- (IBAction)alreadyAuser:(id)sender {
    
}

#pragma mark - Internal Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextfield resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)changeCreateAccountButtonColour{
    
    [self.createAccountButton setBackgroundColor:[UIColor statusLaneGreen]];
}

#pragma mark - Textfield Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.phoneNumberTextfield) {
        
    }
    

}














@end
