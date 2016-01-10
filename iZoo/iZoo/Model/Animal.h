//
//  Animal.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCN.h"
#import <UIKit/UIKit.h>

@interface Animal : NSObject

/**
 *  Full image of the animal
 */
@property  (nonatomic, strong) UIImage  *animalPicture;
/**
 *  Thumbnail of the original image stored in animalPicture
 */
@property  UIImage  *thumbnail;
/**
 *  specie name
 */
@property  NSString *species;
/**
 *  family name
 */
@property  NSString *family;
/**
 *  IUCN is an object composed of two properties, the avreviation and the complete name
 */
@property  IUCN     *iucn;
/**
 *  year
 */
@property  NSInteger year;
/**
 *  image url
 */
@property  NSURL    *imageUrl;
/**
 *  notes
 */
@property  NSString *notes;
/**
 *  this property flag the animal object as favourite based on the webservice response key with the same name
 *  objects not favourites are those who belong to -other- key in the response
 */
@property (nonatomic, assign, getter=isFavourite) BOOL favourite;

@property (nonatomic, assign, getter=isDownloadingImage) BOOL downloadingImage;



/**
 *  Convenience initializer for the class Animal
 *
 *  @param species   specie name
 *  @param family    family
 *  @param iucn      IUCN object
 *  @param year      year
 *  @param stringUrl url as string
 *  @param notes     notes
 *
 *  @return a new allocated instance of Animal class
 */

- (instancetype)initWithSpecieName:(NSString*)species family:(NSString*)family iucn:(IUCN*)iucn year:(NSInteger)year imageUrl:(NSString*)stringUrl notes:(NSString*)notes;

@end




