//
//  Animal.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "Animal.h"
#import <ImageIO/ImageIO.h>

@interface Animal ()
@end

@implementation Animal

- (instancetype)initWithSpecieName:(NSString*)species family:(NSString*)family iucn:(IUCN*)iucn year:(NSInteger)year imageUrl:(NSString*)stringUrl notes:(NSString*)notes{
    self = [super init];
    if (self) {
        _species  = species;
        _family   = family;
        _iucn     = iucn;
        _year     = year;
        _imageUrl = stringUrl.length==0? nil: [NSURL URLWithString:stringUrl];
        _notes = notes;
    }
    return self;
}

- (void)setAnimalPicture:(UIImage *)animalPicture{
    if (!_animalPicture) {
        _animalPicture = animalPicture;
        
        // Fast image processing with image I/O framework according to a test by M. Thompson
        // http://nshipster.com/image-resizing/
        
        NSData* pngData =  UIImageJPEGRepresentation(animalPicture, 0);
        CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
        NSDictionary *options   = @{(__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize:@(120),
                                     (__bridge NSString*)kCGImageSourceCreateThumbnailFromImageAlways:@(YES)};
    
        CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        _thumbnail = [UIImage imageWithCGImage:thumbnail];
        CFRelease(thumbnail);
    }
}

@end
