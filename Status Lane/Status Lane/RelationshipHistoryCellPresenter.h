//
//  RelationshipHistoryCellPresenterTableViewCell.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface RelationshipHistoryCellPresenter : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStatusLabel;
@property (weak, nonatomic) IBOutlet UITextField *userStatusDate;
@property (weak, nonatomic) IBOutlet UITextField *statusDuration;
@end
