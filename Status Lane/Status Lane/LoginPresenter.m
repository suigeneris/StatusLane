//
//  LoginPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "LoginPresenter.h"
#import "LoginInteractor.h"
//#import <Parse/Parse.h>

@interface LoginPresenter ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation LoginPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUiElements];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self countryCodeButton];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<LoginInteractor>)interactor{
    
    if (!_interactor) {
        
        _interactor = [LoginInteractor new];
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
    
    
}

- (IBAction)countryCodePressed:(id)sender {
}

#pragma mark - Internal methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}
@end
