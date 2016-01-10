//
//  DetailViewController.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "DetailViewController.h"
#import "Animal.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem notes];
        self.title = self.detailItem.species;
        self.navigationItem.prompt = self.detailItem.iucn.longName;
        if (self.detailItem.animalPicture)
            [self.imageView setImage:[self.detailItem animalPicture]];
        else
            [self.imageView setImage:[UIImage imageNamed:@"no-image"]];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
