//
//  IUCN.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "IUCN.h"

@implementation IUCN

- (instancetype)initWithAcronym:(NSString *)acronym meaning:(NSString *)meaning {
    self = [super init];
    if (self) {
        _acronym = acronym;
        _longName = meaning;
    }
    return self;
}

- (instancetype)initWithDescription:( NSString *)descr
{
    NSArray *iucnComponents = [descr componentsSeparatedByString:@"("];
    self =  [self initWithAcronym:[NSString stringWithFormat:@"(%@",iucnComponents[1]] meaning:iucnComponents[0]];
    if (self) {
        
    }
    return self;
}


@end
