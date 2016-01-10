//
//  UIImageView+UIImageView_Download.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageView_Download)

/**
 *  This method is intended to be used with UIImageView instances, but some issue with performance were detected
 *  instead use a method provided in the webservice for this purpose
 *
 *  @param url        url of the resource
 *  @param completion the image
 */
- (void)setImageFromUrl:(NSURL*)url completion:( void(^)(UIImage* image) )completion  __deprecated;

- (void)setActivityIndicatorVisible:(BOOL)show  __deprecated;
@end
