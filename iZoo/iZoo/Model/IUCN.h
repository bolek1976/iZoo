//
//  IUCN.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUCN : NSObject
@property  NSString *acronym;
@property  NSString *longName;

/**
 *  Convenience initializer for the class.
 *
 *  @param descr the string in the format @b longname @b(AV) internally the class split the long name and the abreviation and
 *  store each one in the properties @b acronym and @b longName
 *
 *  @return new initialized instance of the IUCN class;
 */
- (instancetype)initWithDescription:(NSString *)descr ;

@end
