//
//  NSString+URLValidations.m
//  iZoo
//
//  Created by Boris Chirino on 10/01/16.
//  Copyright © 2016  All rights reserved.
//

#import "NSString+URLValidations.h"

@implementation NSString (URLValidations)

- (BOOL)isValidUrlString
{
    NSURL *testURL = [NSURL URLWithString:self];
    NSString *urlScheme = testURL.scheme;
    NSString *urlPathExtension = testURL.pathExtension;
    BOOL validScheme    = NO;
    BOOL validImageFile = NO;
    if ([urlScheme isEqualToString:@"https"] || [urlScheme isEqualToString:@"http"]) {
        validScheme = YES;
    }
    if ([urlPathExtension isEqualToString:@"jpg"] || [urlPathExtension isEqualToString:@"png"] ) {
        validImageFile = YES;
    }
    
    return validScheme && validImageFile;
}

@end
