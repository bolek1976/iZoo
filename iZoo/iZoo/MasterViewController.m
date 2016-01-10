//
//  MasterViewController.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ZooWebService.h"
#import "Animal.h"
#import "AnimalTableViewCell.h"
#import "NSString+URLValidations.h"




@interface MasterViewController ()

@property NSMutableArray *animalList;

@end

@implementation MasterViewController


#pragma mark View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    _animalList = [[NSMutableArray alloc] initWithCapacity:0];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    __weak typeof(self) weakSelf = self;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[ZooWebService sharedInstance] getAllAnimalsCompletionSuccess:^(id response) {
        NSLog(@"finished loading items");
        
        // Favourite animals
        for (NSDictionary *animal in response[@"Animals"][@"favourites"])
        {
            [weakSelf saveAnimalData:animal beingFavorite:YES];
        }
        
        // Others Animals
        for (NSDictionary *animal in response[@"Animals"][@"others"])
        {
            [weakSelf saveAnimalData:animal beingFavorite:NO];
        }
        
        
        //ordering
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"species" ascending:YES];
        NSArray *sortedArray = [self.animalList sortedArrayUsingDescriptors:@[sd]];
        [weakSelf setAnimalList:[NSMutableArray arrayWithArray:sortedArray]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.tableView reloadData];
        });
        
        [self downloadImages];
    } failure:^(NSError *response) {
        NSLog(@"error initializing data");
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark utility Methods

/**
 *  Parse and save each animal data, check for url valid resource for download, if is not valid store empty string
 *  it also flag the instance as favorite or not
 *
 *  @param animalData Dictionary containing one animal data
 *  @param favorite   flag indicating if should be marked as favorite or not
 */
- (void)saveAnimalData:(NSDictionary*)animalData beingFavorite:(BOOL)favorite
{
    BOOL validURL = [animalData[@"picture"] isValidUrlString];
    if (!validURL) {
        NSLog(@"endpoint isn't image %@ ",animalData[@"picture"]);
    }
    
    IUCN *animalIUCN   = [[IUCN alloc] initWithDescription:animalData[@"IUCN"]];
    Animal *animalItem = [[Animal alloc] initWithSpecieName:animalData[@"species"]
                                                     family:animalData[@"family"]
                                                       iucn:animalIUCN
                                                       year:[animalData[@"year"] integerValue]
                                                   imageUrl:validURL ? animalData[@"picture"] : @""
                                                      notes:animalData[@"notes"][@"__cdata"]];
    animalItem.favourite = favorite;
    [self.animalList addObject:animalItem];
}


/**
 *  Download images async and asign it to each animalPicture property of Animal instances
 */
- (void)downloadImages
{
    for (Animal *animal in self.animalList) {
        animal.downloadingImage = YES;
        NSUInteger objectIndex = [self.animalList indexOfObject:animal];
        if (animal.imageUrl) {
            [[ZooWebService sharedInstance] downloadImageFromURL:animal.imageUrl completion:^(id response) {
                UIImage *downloadedImage = [UIImage imageWithData:response];
                animal.animalPicture = downloadedImage;
                animal.downloadingImage = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:objectIndex inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[ cellIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }];
        }
        else
        {
            animal.animalPicture = [UIImage imageNamed:@"no-image"];
            animal.downloadingImage = NO;
        }
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Animal *object = self.animalList[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View Delegates & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.animalList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Animal *object = self.animalList[indexPath.row];
    cell.specieLabel.text = object.species;
    cell.familyLabel.text = object.family;
    cell.iucnStatusLabel.text = object.iucn.acronym;
    cell.yearLabel.text = [NSString stringWithFormat:@"%li",(long)object.year];
    cell.favouriteIcon.image = object.isFavourite ? [UIImage imageNamed:@"favourite_on"] : [UIImage imageNamed:@"favourite_off"];
    if (!object.isDownloadingImage) {
        [cell.activityIndicator stopAnimating];
    }
    [cell.imageView setImage: object.thumbnail];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.animalList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
