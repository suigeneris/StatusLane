//
//  VerifyAccountViewController.m
//  Status Lane
//
//  Created by Jonathan Aguele on 19/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "VerifyAccountPresenter.h"
#import "VerifyAccountInteractor.h"
#import "StatusLaneErrorView.h"
#import "StatusLaneButtonGreen.h"
#import "UIColor+StatusLane.h"



@interface VerifyAccountPresenter () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet StatusLaneButtonGreen *registerButton;

@end

@implementation VerifyAccountPresenter

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setAttributesForUILabel];
    NSLog(@"%@", self.phonenumber);
    NSLog(@"%@", self.password);
    NSLog(@"verification code passed on through segue: %@", self.verificationCode);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<VerifyAccountInteractor>)interactor{
    
    if (!_interactor) {
        
        VerifyAccountInteractor *interactor = [VerifyAccountInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    }
    
    return _interactor;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IB Outlets

- (IBAction)backArrowPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerButtonnPressed:(id)sender {
    
    [self validateDataInTextFields];
}

- (IBAction)resentButtonPressed:(id)sender {
    
   self.verificationCode = [self.interactor resendVerificationCodeToNumber:self.phonenumber];
    NSLog(@"new verification code : %@", self.verificationCode);
}

#pragma mark - Additional UI Setup

- (void)setAttributesForUILabel {
    
    self.passwordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"re-type password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.verificationCodeTextfield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.verificationCodeTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"verification code" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordTextField.delegate = self;
    self.verificationCodeTextfield.delegate = self;
}

#pragma mark - Internal Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.verificationCodeTextfield resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)validateDataInTextFields{
    
    [self touchesBegan:[NSSet new] withEvent:nil];
    if ([self.verificationCode isEqualToString:self.verificationCodeTextfield.text]) {
        
        if ([self.password isEqualToString:self.passwordTextField.text]) {
            
            [self.interactor queryParseForAnonymousUser:self.phonenumber andPasswordIfAnonymousUserIsFound:self.password];

        }
        else{
            
            [self showErrorViewWithMessage:@"Passwords Dont Match"];
        }
        
    }
    
    else{
        
        [self showErrorViewWithMessage:@"Verification Codes Dont Match"];

    }
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
#pragma mark - Presenter Delegate Methods

-(void)showErrorViewWithMessage:(NSString *)message {
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:message andTitle:@"OOOOPs!"];
    [errorView showWithCompletionBlock:nil];

}

-(void)createAccountSuccessfull{
    
    [self performSegueWithIdentifier:@"AccountCreated" sender:self];

    
}

-(void)showActivityView{
    
    self.registerButton.userInteractionEnabled = NO;
    [self activityIndicator];
    
}

-(void)hideActivityView{
    
    self.registerButton.userInteractionEnabled = YES;
    [self hide];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textFieldf{
    
    [self.registerButton setBackgroundColor:[UIColor statusLaneGreen]];

}

















@end

