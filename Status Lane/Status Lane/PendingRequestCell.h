//
//  PendingRequestCell.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface PendingRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
