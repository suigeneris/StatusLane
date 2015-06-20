//
//  ChoosePartnerPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ChoosePartnerPresenter.h"
#import "ChoosePartnerInteractor.h"


@interface ChoosePartnerPresenter ()

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *partnerNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *contactListButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


@end

@implementation ChoosePartnerPresenter

-(void)awakeFromNib{
    
    [super awakeFromNib];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUPUIElements];
    self.contactListTableView.delegate = self.interactor;
    self.contactListTableView.dataSource = [self.interactor dataSource];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self countryCodeButton];

}

-(void)viewDidAppear:(BOOL)animated{
    
    //[self viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTableView" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<ChoosePartnerInteractorDelegate, UITableViewDelegate, ChoosePartnerInteractorDataSource >)interactor{
    
    if (!_interactor) {
        
        ChoosePartnerInteractor *interactor = [ChoosePartnerInteractor new];
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

-(void)setUPUIElements{
    
    self.navigationBarView.backgroundColor = [UIColor colorWithRed:0
                                                             green:0
                                                              blue:0
                                                             alpha:0.3
                                              ];
    
    [self.contactListTableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    
    self.contactListTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"phone number" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.partnerNameTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.partnerNameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"name" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.countryCodeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.phoneNumberButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    

    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Internal Methods

-(void)saveStatusToDefaults{
    
    [self.interactor saveStatusToDefaults:self.usersChosenStatus];
}
#pragma mark - IBOutlets

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)countryCodeButtonPressed:(id)sender {
}

- (IBAction)phoneNumberButtonPressed:(id)sender {
    
    [self switchButtonsBackgroundColor:sender];
    [self hideUIElements:sender];
}

- (IBAction)contactListButtonPressed:(id)sender {
    
    [self switchButtonsBackgroundColor:sender];
    [self hideUIElements:sender];
    [self.interactor askUserForPermissionToViewContacts];

}

- (IBAction)sendButtonPressed:(id)sender {
    
    [self saveStatusToDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Logic for View manipulation 

-(void)hideUIElements:(id)sender {
    
    UIButton *pressedButton = (UIButton*)sender;
    
    if (pressedButton.tag == 1) {
        
        self.countryCodeButton.hidden = NO;
        self.phoneNumberTextfield.hidden = NO;
        self.partnerNameTextField.hidden = NO;
        self.sendButton.hidden = NO;
        self.contactListTableView.hidden = YES;
}
    
    else if (pressedButton.tag == 2){
        
        self.countryCodeButton.hidden = YES;
        self.phoneNumberTextfield.hidden = YES;
        self.partnerNameTextField.hidden = YES;
        self.sendButton.hidden = YES;
        self.contactListTableView.hidden = NO;
        
    }
    
}

-(void)switchButtonsBackgroundColor:(id)sender {
    
    UIButton *selectedButton = (UIButton*)sender;
    
    if (selectedButton.tag == 1) {
        
        selectedButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        self.contactListButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    
    else{
        
        selectedButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        self.phoneNumberButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextfield resignFirstResponder];
    [self.partnerNameTextField resignFirstResponder];

}




#pragma mark - Choose Partner Presenter Delegate

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error andActionTitle:(NSString *)actionTitle{
    
    UIAlertController *cantAddContactAlert = [UIAlertController alertControllerWithTitle:title
                                                                                 message:error
                                                                          preferredStyle:UIAlertControllerStyleAlert
                                              ];
    
    [cantAddContactAlert addAction:[UIAlertAction actionWithTitle:actionTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                            
                                                              [self.interactor openSettings];
                                                              
                                                              
                                                          }]];
    
    [self presentViewController:cantAddContactAlert animated:YES completion:nil];
    
}

-(void)reloadData{
    
    NSLog(@"reload the fucking data mate");
    //TODO:Need to fix this non reloading table
    [self.contactListTableView reloadData];
}

-(void)dismissTabelViewWithPartnerName:(NSString *)name andNumber:(NSString *)number{
    
    [self contactListButtonPressed:self.phoneNumberButton];
    self.partnerNameTextField.text = name;

}











@end
