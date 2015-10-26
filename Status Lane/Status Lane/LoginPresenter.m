//
//  LoginPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "LoginPresenter.h"
#import "LoginInteractor.h"
#import "StatusLaneErrorView.h"
#import "StatusLaneButtonGreen.h"
#import "StatusLaneErrorView.h"
#import "NSString+StatusLane.h"
#import "UIColor+StatusLane.h"


static void *countryCodeContext = &countryCodeContext;


@interface LoginPresenter () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet StatusLaneButtonGreen *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *isValidLabel;


@end

@implementation LoginPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUiElements];
    [self.interactor loginCachedUser];
    // Do any additional setup after loading the view.

}



-(void)viewWillAppear:(BOOL)animated{
    
    [self countryCodeButton];
    [self.phoneNumberTextfield addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextfield addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    @try {
        
        [self.countryCodeButton removeObserver:self forKeyPath:@"text" context:countryCodeContext];
        
    }
    @catch (NSException * __unused exception) {
        
    }
    
}

-(id<LoginInteractor>)interactor{
    
    if (!_interactor) {
        
        LoginInteractor *interactor = [LoginInteractor new];
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

-(void)setUpUiElements {
    
    self.countryCodeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    
    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"mobile number" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.passwordTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"password" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passwordTextfield.clearsOnInsertion = YES;
    self.passwordTextfield.clearsOnBeginEditing = YES;

    self.passwordTextfield.delegate = self;
    [self.countryCodeButton.titleLabel addObserver:self
                                        forKeyPath:@"text"
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:countryCodeContext];

}

#pragma mark - IB Outlets

- (IBAction)countryCodePressed:(id)sender {
}

- (IBAction)loginButtonPressed:(id)sender {

    [self.interactor attemptLoginWithUsername:[self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text] andPassword:self.passwordTextfield.text];
}

#pragma mark - Presenter Delegate Methods

-(void)showErrorViewWithErrorMessage:(NSString *)errorMessage{
    
    [self touchesBegan:[NSSet new] withEvent:nil];
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:errorMessage andTitle:@"OOOOPs!"];
    [errorView showWithCompletionBlock:nil];
}

-(void)login{

    [self performSegueWithIdentifier:@"Login" sender:self];
    
}

-(void)showActivityView{
    
    self.loginButton.userInteractionEnabled = NO;
    [self activityIndicator];
    
}

-(void)hideActivityView{
    
    [self hide];
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField == self.passwordTextfield) {
        
        [self validatePassword];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.passwordTextfield) {
        
        [self validatePassword];
    }
}


#pragma mark - Internal methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.isValidLabel.hidden = YES;
    [self.phoneNumberTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    

}

-(void)validatePhoneNumber{
    
    if ([self isNumberInTextFieldValid]) {
        
        self.isValidLabel.hidden = YES;
        
    }
    
    else{
        
        self.isValidLabel.text = @"number invalid";
        self.isValidLabel.hidden = NO;
        self.loginButton.backgroundColor = [UIColor statusLaneGreenPressed];
        self.loginButton.userInteractionEnabled = NO;
        
    }
    
}

-(void)validatePassword{
    
    
    if ((self.passwordTextfield.text != nil) && [self.passwordTextfield.text length] > 0 && [self.passwordTextfield.text isEqualToString:@""] == false && [self isNumberInTextFieldValid]) {
        
        self.loginButton.userInteractionEnabled = YES;
        self.loginButton.backgroundColor = [UIColor statusLaneGreen];
    }
    else{
        
        self.loginButton.userInteractionEnabled = NO;
        self.loginButton.backgroundColor = [UIColor statusLaneGreenPressed];
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
    
    self.loginButton.userInteractionEnabled = YES;
    [[self.view viewWithTag:1111] removeFromSuperview];
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
