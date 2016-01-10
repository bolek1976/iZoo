//
//  UIImageView+UIImageView_Download.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "UIImageView+UIImageView_Download.h"
#import "ZooWebService.h"

#define kActivityIndicatorTag 999999

@implementation UIImageView (UIImageView_Download)


- (void)setImageFromUrl:(NSURL *)url completion:(void (^)(UIImage *))completion{
    [self setActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    if (url == nil)
            return;
    
    UIImage *cachedImage = [[ZooWebService sharedInstance] cachedImageForKey:url.absoluteString];
    if (cachedImage) {
        completion(cachedImage);
        return;
    }

    [[ZooWebService sharedInstance] downloadImageFromURL:url completion:^(id response) {
        if (response) {
            UIImage *downloadedImage = [UIImage imageWithData:response];
            [weakSelf setActivityIndicatorVisible:NO];
            completion(downloadedImage);
        }else{
            [weakSelf setActivityIndicatorVisible:NO];
            completion(nil);
        }

    }];
}

- (void)setActivityIndicatorVisible:(BOOL)show
{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:kActivityIndicatorTag];
    
    if (activity == nil)
    {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.color = [UIColor blackColor];
        activity.tag = kActivityIndicatorTag;
        activity.hidesWhenStopped = YES;
        activity.center = CGPointMake(30, 20);
        [self addSubview:activity];
    }
    if (show)
        [activity startAnimating];
    else
        [activity stopAnimating];
}


@end
