//
//  NSString+URLValidations.h
//  iZoo
//
//  Created by Boris Chirino on 10/01/16.
//  Copyright © 2016  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLValidations)
/**
 *  this method validate the url based only in the schema (http or https) and also check the filename extension of the
 *  url jpg/png to proper proced on dowloading the resource
 *
 *  @param urlString the url as string
 *
 *  @return true or false depending on criteria ecplained in description section
 */

- (BOOL)isValidUrlString;

@end
