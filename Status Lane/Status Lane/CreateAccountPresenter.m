//
//  CreateAccountPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CreateAccountPresenter.h"
#import "CreateAccountInteractor.h"
#import "VerifyAccountPresenter.h"
#import "StatusLaneErrorView.h"
#import "UIColor+StatusLane.h"
#import "NSString+StatusLane.h"
#import <Parse/Parse.h>

static void *countryCodeContext = &countryCodeContext;

@interface CreateAccountPresenter () <UITextFieldDelegate>
    
@property (weak, nonatomic) IBOutlet UILabel *statusLaneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *isValidLabel;
@property (nonatomic, strong) NSString *verificationCode;

@end

@implementation CreateAccountPresenter
    


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setAttributesForUILabel];
    


}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showVerify"]) {
        
        VerifyAccountPresenter *vc = [[VerifyAccountPresenter alloc]init];
        vc = segue.destinationViewController;
        vc.phonenumber = [self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text];
        vc.password = self.passwordTextField.text;
        vc.verificationCode = self.verificationCode;
    
    }
}

-(void)dealloc{
    
    @try {
        
        [self.countryCodeButton removeObserver:self forKeyPath:@"text" context:countryCodeContext];

    }
    @catch (NSException * __unused exception) {
        
    }
   
}

-(void)viewWillAppear:(BOOL)animated{

    [self countryCodeButton];
    [self.phoneNumberTextfield addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];


}

-(id<CreateAccountInteractor>)interactor{
    
    if (!_interactor) {
        
        CreateAccountInteractor *interactor = [CreateAccountInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
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
    
    self.passwordTextField.clearsOnInsertion = YES;
    self.passwordTextField.clearsOnBeginEditing  = YES;
    
    
    [self.countryCodeButton.titleLabel addObserver:self
                                        forKeyPath:@"text"
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:countryCodeContext];
    
    self.passwordTextField.delegate = self;
}

#pragma mark - Internal Methods


-(void)validatePhoneNumber{
    
    if ([self isNumberInTextFieldValid]) {
        
        self.isValidLabel.hidden = YES;
        
    }
    
    else{
        
        self.isValidLabel.text = @"number invalid";
        self.isValidLabel.hidden = NO;
        self.createAccountButton.backgroundColor = [UIColor statusLaneGreenPressed];
        self.createAccountButton.userInteractionEnabled = NO;

    }
    
}

-(void)validatePassword{
    
    
    if ((self.passwordTextField.text != nil) && [self.passwordTextField.text length] > 0 && [self.passwordTextField.text isEqualToString:@""] == false && [self isNumberInTextFieldValid]) {
        
        self.createAccountButton.userInteractionEnabled = YES;
        self.createAccountButton.backgroundColor = [UIColor statusLaneGreen];
    }
    else{
        
        self.createAccountButton.userInteractionEnabled = NO;
        self.createAccountButton.backgroundColor = [UIColor statusLaneGreenPressed];
    }
    
}

-(BOOL)isNumberInTextFieldValid{
    
    NSString *fullNumber = [self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text];
    BOOL isNumberValid = [NSString isPhoneNumberValid:fullNumber];
    return isNumberValid;
    
}

-(void)activityIndicator{
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    activityView.color = [UIColor statusLaneGreenPressed];
    activityView.hidesWhenStopped = YES;
    activityView.tag=1111;
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    
}

-(void)hide{
    
    [[self.view viewWithTag:1111] removeFromSuperview];
}
#pragma mark - IB Outlets Methods

- (IBAction)continueButtonPressed:(id)sender {
    
    [self touchesBegan:[NSSet new] withEvent:nil];
    NSString  *string = [self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text];
    self.verificationCode = [self.interactor generateVerificationCode];
    [self.interactor queryParseForUsernmae:string andCode:self.verificationCode];
}

- (IBAction)alreadyAuser:(id)sender {
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextfield resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)changeCreateAccountButtonColour{
    
    [self.createAccountButton setBackgroundColor:[UIColor statusLaneGreen]];
}





#pragma mark - Presenter Delegate Methods

-(void)showErrorView:(NSString *)errorMessage{
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:errorMessage color:[UIColor statusLaneRed] andTitle:@"OOOOPs!"];
    [errorView showWithCompletionBlock:nil];
}

-(void)showVerifyAccount{
    
    [self performSegueWithIdentifier:@"showVerify" sender:self];
    
}


-(void)showActivityView{
    
    self.createAccountButton.userInteractionEnabled = NO;
    [self activityIndicator];
    
}

-(void)hideActivityView{
    
    self.createAccountButton.userInteractionEnabled = YES;
    [self hide];
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    

    if (textField == self.passwordTextField) {
        
        [self validatePassword];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.passwordTextField) {
        
        [self validatePassword];
    }
}


#pragma mark - Key Value Observer 

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (context == countryCodeContext)
    {
        if ([[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]] ) {
            
        }
        
        else{
            
            [self validatePhoneNumber];

        }
    }

}










@end
