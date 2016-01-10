//
//  AnimalTableViewCell.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *favouriteIcon;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *specieLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyLabel;
@property (weak, nonatomic) IBOutlet UILabel *iucnStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
