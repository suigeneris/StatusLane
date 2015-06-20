//
//  ForgotPasswordPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ForgotPasswordPresenter.h"
#import "ForgotPasswordInteractor.h"

@interface ForgotPasswordPresenter ()

@property (weak, nonatomic) IBOutlet UIButton *countrycodeButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextfield;
@end

@implementation ForgotPasswordPresenter

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

-(id<ForgotPasswordInteractor>)interactor{
    
    if (!_interactor) {
        
        _interactor = [ForgotPasswordInteractor new];
        
    }
    return _interactor;
}

-(UIButton *)countryCodeButton{
    
    if (_countrycodeButton) {
        
        NSString *string = [self.interactor requestCountryCode];
        if (string == (id)[NSNull null] || string.length == 0 ) {
            
            [_countrycodeButton setTitle:@"+44" forState:UIControlStateNormal];
        }
        
        else{
            
            [_countrycodeButton setTitle:string forState:UIControlStateNormal];
        }
    }
    
    return _countrycodeButton;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI View Setup

-(void)setUpUiElements {
    
    self.countrycodeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    
    self.mobileNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.mobileNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"mobile number" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (IBAction)submitButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.mobileNumberTextfield resignFirstResponder];
}

@end
