//
//  DetailViewController.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Animal;
@interface DetailViewController : UIViewController

@property (strong, nonatomic) Animal *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

