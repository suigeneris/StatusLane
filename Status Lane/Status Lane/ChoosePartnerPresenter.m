//
//  ChoosePartnerPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ChoosePartnerPresenter.h"
#import "UIColor+StatusLane.h"
#import "NSString+StatusLane.h"
#import "StatusLaneErrorView.h"


static void *countryCodeContext = &countryCodeContext;

@interface ChoosePartnerPresenter () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *partnerNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *contactListButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *numberValidityLabel;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;


@end

@implementation ChoosePartnerPresenter

-(void)awakeFromNib{
    
    [super awakeFromNib];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUPUIElements];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self countryCodeButton];
    [self.phoneNumberTextfield addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];
    [self.partnerNameTextField addTarget:self action:@selector(checkPartnerName) forControlEvents:UIControlEventEditingChanged];



}

-(void)viewDidAppear:(BOOL)animated{
    
    //[self viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTableView" object:nil];

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

-(id<ChoosePartnerInteractorDelegate, UITableViewDelegate, ChoosePartnerInteractorDataSource >)interactor{
    
    if (!_interactor) {
        
        ChoosePartnerInteractor *interactor = [ChoosePartnerInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
        self.searchBar.delegate = _interactor;
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

-(UIActivityIndicatorView *)activityIndicator{
    
    if (!_activityIndicator) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.center = self.view.center;
        _activityIndicator.color = [UIColor statusLaneGreenPressed];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.tag = 1111;
    }
    return _activityIndicator;
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
    
    
    [self.countryCodeButton.titleLabel addObserver:self
                                        forKeyPath:@"text"
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:countryCodeContext];
    
    self.contactListTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"phone number" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.partnerNameTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.partnerNameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"full name" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.countryCodeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.phoneNumberButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    
    self.contactListTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.contactListTableView.sectionIndexColor = [UIColor statusLaneGreen];
    [self customiseSearchBar];
    
    self.phoneNumberTextfield.delegate = self;
    self.phoneNumberTextfield.delegate = self;
    

    

}

-(void)customiseSearchBar {
    
    UITextField *textfield = [self.searchBar valueForKey:@"_searchField"];
    
    textfield.textColor = [UIColor whiteColor];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil]setTextColor:[UIColor statusLaneGreen]];
    
    [textfield setBackgroundColor:[UIColor colorWithRed:1
                                                  green:1
                                                   blue:1
                                                  alpha:0.03
                                   ]];
    
    [self.contactListTableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];
    
    self.searchBar.tintColor = [UIColor colorWithRed:1
                                               green:1
                                                blue:1
                                               alpha:1
                                ];
    
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
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
    
    [self.interactor saveStatusToDefaults:self.usersChosenStatus andPartnerName:self.partnerNameTextField.text];
}

-(BOOL)isNumberInTextFieldValid{
    
    NSString *fullNumber = [self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text];
    BOOL isNumberValid = [NSString isPhoneNumberValid:fullNumber];
    return isNumberValid;
    
}

-(void)validatePhoneNumber{
    
    if ([self isNumberInTextFieldValid]) {
        
        self.numberValidityLabel.hidden = YES;
        
        if (![self.partnerNameTextField.text isEqualToString:@""]) {
            
            self.sendButton.userInteractionEnabled = YES;
            [self.sendButton setBackgroundColor:[UIColor statusLaneGreen]];
        }
    }
    
    else{
        
        self.numberValidityLabel.hidden = NO;
        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setBackgroundColor:[UIColor statusLaneGreenPressed]];
        
    }
    
}

-(void)checkPartnerName{
    
    if (![self.partnerNameTextField.text isEqualToString:@""] && [self isNumberInTextFieldValid]) {
        
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setBackgroundColor:[UIColor statusLaneGreen]];
    }
    else {
    
        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setBackgroundColor:[UIColor statusLaneGreenPressed]];
    }
}




#pragma mark - IBOutlets

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)countryCodeButtonPressed:(id)sender {
}

- (IBAction)phoneNumberButtonPressed:(id)sender {
    
    [self.searchBar resignFirstResponder];
    [self switchButtonsBackgroundColor:sender];
    [self hideUIElements:sender];
}

- (IBAction)contactListButtonPressed:(id)sender {
    
    [self touchesBegan:nil withEvent:nil];
    [self switchButtonsBackgroundColor:sender];
    [self hideUIElements:sender];
    self.contactListTableView.delegate = self.interactor;
    self.contactListTableView.dataSource = [self.interactor dataSource];
    [self.interactor askUserForPermissionToViewContacts];

}

- (IBAction)sendButtonPressed:(id)sender {
    
    [self saveStatusToDefaults];
    [self touchesBegan:nil withEvent:nil];
    [self.interactor updateUserPartnerWithFullName:self.partnerNameTextField.text andNumber:[self.countryCodeButton.titleLabel.text stringByAppendingString:self.phoneNumberTextfield.text]];
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
    
    self.numberValidityLabel.hidden = YES;
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
    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.contactListTableView reloadData];
        
    });
}


-(void)dismissTabelViewWithPartnerName:(NSString *)name andNumber:(NSString *)number{
    
    [self dismissSearchBar];
    [self contactListButtonPressed:self.phoneNumberButton];
    self.partnerNameTextField.text = name;
    self.phoneNumberTextfield.text = number;
    [self checkPartnerName];
    [self validatePhoneNumber];

}

-(void)dismissSearchBar{
    
    [self.searchBar resignFirstResponder];
}

-(void)dismissView{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)showErrorView:(NSString *)errorMessage{
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:errorMessage];
    [errorView show];
}

-(void)startAnimatingActivityView{
    
    [self.view addSubview:self.activityIndicator];
    [_activityIndicator startAnimating];
}

-(void)stopAnimatingActivitiyView{
    
    [_activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
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
