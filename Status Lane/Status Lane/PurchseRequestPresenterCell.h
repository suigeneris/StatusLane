//
//  PurchseRequestPresenterCell.h
//  Status Lane
//
//  Created by Jonathan Aguele on 07/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchseRequestPresenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seletedButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRequestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
