//
//  HomePagePresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "HomePagePresenter.h"
#import "HomePageInteractor.h"
#import "UIFont+StatusLaneFonts.h"
#import "UIColor+StatusLane.h"
#import "SWRevealViewController.h"
#import "StatusListPresenterCell.h"
#import "ChoosePartnerPresenter.h"
#import "StatusLaneErrorView.h"



@interface HomePagePresenter () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *partnerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerName;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenu;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *quoteOfTheDay;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) bool isTableViewHidden;
@property (nonatomic, strong) UITapGestureRecognizer *tapToHideTableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;


@property (nonatomic, strong) NSIndexPath *indexPathForSelectedCell;


//NSLayout Constraints
@property (nonatomic, strong) NSLayoutConstraint *tableViewLeading;
@property (nonatomic, strong) NSLayoutConstraint *tableViewTrailing;
@property (nonatomic, strong) NSLayoutConstraint *tableViewTop;
@property (nonatomic, strong) NSLayoutConstraint *tableViewBottom;

@property (nonatomic, strong) NSLayoutConstraint *animateTableViewLeading;
@property (nonatomic, strong) NSLayoutConstraint *animateTableViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageViewCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partnerProfileImageViewCenterX;


@end

@implementation HomePagePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self additionalUIViewSetup];
    [self revealControllerSetUp];
    [self constraintsForTableView];
    

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.relationshipStatusLabel.text = [self.interactor returnUserStatusFromDefaults];
    self.partnerName.text = [self.interactor returnPartnerName];
    [self setFullNameLabel:self.fullNameLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(hideTableView)
                                                name:@"HideTableView"
                                              object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImagePickerController *)imagePicker{
    
    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self.interactor;
        _imagePicker.allowsEditing = NO;

    }
    
    return _imagePicker;
}

-(id<HomePageInteractorDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, HomePageDataSource, UITableViewDelegate>)interactor{
    
    if (!_interactor) {
        HomePageInteractor *interactor = [HomePageInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    }
    return _interactor;
}

-(UITapGestureRecognizer *)tapToHideTableView{
    
    if (!_tapToHideTableView) {
        
        _tapToHideTableView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTableView)];
        _tapToHideTableView.delegate = self;
    }
    
    return _tapToHideTableView;
}

-(UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        
        _backgroundImageView.image = [self.interactor returnBackgroundImageFromFile];
    }
    
    return _backgroundImageView;
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

-(void)additionalUIViewSetup{
    
    [self.bottomUIView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    NSLayoutConstraint *buttomUIViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomUIView
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                   multiplier:0.30
                                                                                     constant:0
                                                        ];
    
    [self.view addConstraint:buttomUIViewHeightConstraint];

    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self chooseProfileImage];
    [self setBackGroundImage];
    
    _partnerProfileImage.hidden = YES;
    _partnerProfileImage.layer.borderWidth = 2;
    _partnerProfileImage.layer.cornerRadius = _partnerProfileImage.frame.size.width/2;
    _partnerProfileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _partnerProfileImage.clipsToBounds = YES;
    

    
}

-(void)setFullNameLabel:(UILabel *)fullNameLabel{
    
    if ([Defaults fullName]) {
        
        fullNameLabel.text = [Defaults fullName];
        fullNameLabel.userInteractionEnabled = NO;
        
    }else{
        
        fullNameLabel.text = @"Full Name";
    }
}

-(void)revealControllerSetUp{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.burgerMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showChoosePartner"]) {
        
        StatusListPresenterCell *cell = (StatusListPresenterCell *)[self.tableview cellForRowAtIndexPath:self.indexPathForSelectedCell];
        ChoosePartnerPresenter *vc = segue.destinationViewController;
        vc.usersChosenStatus = cell.statusTypeLabel.text;
    }

}

#pragma mark - IBOutlets

- (IBAction)pressedChangeBackgroundImageButton:(id)sender {
    
    [self showChooseImageActionSheet:0];
}


- (IBAction)relationshipStatusPressed:(id)sender {
    
    [self showTableView];
}

- (IBAction)addProfileImagePressed:(UITapGestureRecognizer *)sender {
    
    [self showChooseImageActionSheet:1];
}


#pragma mark - Internal Methods

-(void)showChooseImageActionSheet:(int) sender {
    
    UIAlertController *chooseImageActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleActionSheet
                                                 
                                                 ];
    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Take A Picture"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                
                                                                if ([self.interactor checkImagePickerSourceTypeAvailability:[self class]]) {
                                                                    
                                                                    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera from:sender];
                                                                }
                                                                
                                                                else{
                                                                    
                                                                    [self showAlertWithTitle:@"Error"
                                                                                errorMessage:@"Device Has No Camera"
                                                                              actionTitle:@"Ok"
                                                                     withStyle:UIAlertControllerStyleAlert
                                                                                   withBlock:nil];

                                                                }
            
                                                            }]];
    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Photos"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary from:sender];
                                                                 
                                                             }]];
    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                             }]];
    
    
    [self presentViewController:chooseImageActionSheet animated:YES completion:nil];
                                                   
    
}


-(void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType from:(int)alertViewFrom{
    
    self.imagePicker.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 40.0);
        _imagePicker.cameraViewTransform = translate;
        CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
        _imagePicker.cameraViewTransform = scale;
        //_imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
    }
    
    NSString *accessGranted = [self.interactor checkAuthorizationForSourceType:sourceType];
    
    [self.interactor setFlagForAlertViewButtonPressed:alertViewFrom];
    
    [self presentViewController:_imagePicker animated:YES completion:^{
        
        if ([accessGranted isEqualToString:@"Authorised"]) {
            
        }
        
        else if ([accessGranted isEqualToString:@"Denied"] || [accessGranted isEqualToString:@"Restricted"]) {
            
            [_imagePicker presentViewController:[self alertViewForImagePickerFromSourceType:sourceType] animated:YES completion:nil];
            
        }
        
        else if ([accessGranted isEqualToString:@"Not Determined"]){
            
        }
        
    }];
    
}

-(UIAlertController *)alertViewForImagePickerFromSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:sourceType ? @"We need Access to camera" : @"We need access to photos"
                                                            preferredStyle:UIAlertControllerStyleAlert
                                
                                ];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                
                                                [self.interactor openSettings];
                                                
                                            }]];
    
    return alert;
    
    
}



#pragma mark - Presenter Delegate Methods

-(void)setBackGroundImage{
    
    self.backgroundImageView.image = [self.interactor returnBackgroundImageFromFile];
    
}

-(void)chooseProfileImage{
    
    self.profileImage.image = [self.interactor returnProfileImageFromFile];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.borderWidth = 2;
    self.profileImage.clipsToBounds = YES;
}

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error actionTitle:(NSString *)actionTitle withStyle:(UIAlertControllerStyle)style withBlock:(AlertControllerBlock)alertViewBlock{
    
    UIAlertController *noCamera = [UIAlertController alertControllerWithTitle:title
                                                                      message:error
                                                               preferredStyle:style
                                   ];
    
    [noCamera addAction:[UIAlertAction actionWithTitle:actionTitle
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  
                                                  if (alertViewBlock) {
                                                      
                                                      alertViewBlock();
                                                  }
                                                  
                                                  else{
                                                  }
                                                  
                                              }]];
    
    [self presentViewController:noCamera animated:YES completion:nil];
    
    
}

-(void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dissmissImageCropper{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showImageCropper:(UIImage *)image{
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self.interactor;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

-(void)showChoosePartner{
    
    [self performSegueWithIdentifier:@"showChoosePartner" sender:self];
}

-(void)indexPathForSelectedRow:(NSIndexPath *)indexPath{
    
    self.indexPathForSelectedCell = indexPath;
}

-(void)changeUserStatusToSingle{
    
    self.relationshipStatusLabel.text = @"SINGLE";
}


-(void)animateViews{
    
    self.partnerProfileImage.hidden = NO;
    self.partnerName.hidden = NO;
    self.profileImageViewCenterX.constant = 100;
    self.partnerProfileImageViewCenterX.constant = 100;
    
    [UIView animateWithDuration:0.36
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     }];
}

-(void)resetImageViewsPostition{
    
    self.profileImageViewCenterX.constant = 0;
    self.partnerProfileImageViewCenterX.constant = 0;
    self.partnerName.hidden = YES;
    
    [UIView animateWithDuration:0.36
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     }];
    
}

-(void)startAnimatingActivityView{
    
    [self.view addSubview:self.activityIndicator];
    [_activityIndicator startAnimating];
}

-(void)stopAnimatingActivitiyView{
    
    [_activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
}

-(void)showErrorView:(NSString *)errorMessage{
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:errorMessage];
    [errorView show];
}

#pragma mark - UIGestureReognizer Delegate Methods

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint touchPoint = [touch locationInView:self.view];
    return !CGRectContainsPoint(self.tableview.frame, touchPoint);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Table view setup
#pragma mark - UIGestureReognizer Table view setup


-(void)constraintsForTableView{
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableview.dataSource = [self.interactor dataSource];
    self.tableview.delegate = self.interactor;
    self.tableview.rowHeight = 80;
    self.tableview.layer.cornerRadius = 4;
    [self.view addSubview:self.tableview];
    
    
    self.tableViewLeading = [NSLayoutConstraint constraintWithItem:self.tableview
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:20
                             ];
    
    self.tableViewTrailing = [NSLayoutConstraint constraintWithItem:self.tableview
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:-20
                              ];
    
    self.tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableview
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:[UIScreen mainScreen].bounds.size.height
                         ];
    
    self.tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableview
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:[UIScreen mainScreen].bounds.size.height - 148
                            ];
    
    [self.view addConstraint:self.tableViewLeading];
    [self.view addConstraint:self.tableViewTrailing];
    [self.view addConstraint:self.tableViewTop];
    [self.view addConstraint:self.tableViewBottom];

    
}

-(void)showTableView{
    
    _isTableViewHidden = NO;
    self.burgerMenu.userInteractionEnabled = NO;
    self.searchButton.userInteractionEnabled = NO;
    
    [self.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view removeGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.tapToHideTableView];

    self.burgerMenu.alpha = 0.3;
    self.searchButton.alpha = 0.3;
    
    _tableViewTop.constant = 86;
    _tableViewBottom.constant = -62;
    
    [UIView animateWithDuration:0.30
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                     }];
}


-(void)hideTableView{
    
    _isTableViewHidden = YES;
    self.burgerMenu.userInteractionEnabled = YES;
    self.searchButton.userInteractionEnabled = YES;
    
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
    [self.view removeGestureRecognizer:self.tapToHideTableView];

    self.burgerMenu.alpha = 1;
    self.searchButton.alpha = 1;
    _tableViewTop.constant = [UIScreen mainScreen].bounds.size.height;
    _tableViewBottom.constant = [UIScreen mainScreen].bounds.size.height - 148;
    
    [UIView animateWithDuration:0.30
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                     }];
    

}






@end
