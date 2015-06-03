//
//  VerifyAccountViewController.m
//  Status Lane
//
//  Created by Jonathan Aguele on 19/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "VerifyAccountPresenter.h"

@interface VerifyAccountPresenter ()
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation VerifyAccountPresenter

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setAttributesForUILabel];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backArrowPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAttributesForUILabel {
    
    self.passwordTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.verificationCodeTextfield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.verificationCodeTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"verification code" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.verificationCodeTextfield resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
