//
//  ZooWebService.m
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import "ZooWebService.h"
#import <Foundation/Foundation.h>

@class ZooWebService;
static ZooWebService *_instance = nil;

@interface ZooWebService ()
 @property NSURLSession *session;
@end

@implementation ZooWebService

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [ZooWebService new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageCache = [NSMutableDictionary new];
        // Session configuration is created ephemeral because this app is optimized for memory architecture, it does not
        // persist any data to disk
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 20;
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                    delegate:self
                                               delegateQueue:nil];
    }
    return self;
}

- (void)getAllAnimalsCompletionSuccess:(void(^)(id response))completion failure:( void(^)(NSError *response))failure{
    NSURL *url = [NSURL URLWithString:@"https://zoomock.firebaseio.com/.json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    if (![request valueForHTTPHeaderField:@"Content-Type"])
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSError *serializationError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:&serializationError];
            if (serializationError)
                failure(serializationError);
            else
                completion(result);
        }
        else
            failure(error);
    }];
    [dataTask resume];
}

- (void)downloadImageFromURL:(NSURL *)url completion:(void (^)(id))completion
{
    if (!url) return;
    
    if ([[self.imageCache allKeys] containsObject:url.absoluteString])
    {
      NSData *cachedImageData =  [self.imageCache objectForKey:url.absoluteString];
      completion(cachedImageData);
      return;
    }

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    __weak typeof(self) weakSelf = self;
    
    // NSURLSessionDownloadTask is used for future releases on big resource being downloaded, move to background
    // the download and keep working on background.
     NSURLSessionDownloadTask *downloadTask =
    [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSError *downloadError = nil;
         NSData *downloadedItem =  [NSData dataWithContentsOfURL:location options:NSDataReadingMappedAlways error:&downloadError];
         if (![response.MIMEType isEqualToString:@"image/jpeg"])
             completion(nil);
         else
         {
             [weakSelf.imageCache setObject:downloadedItem forKey:url.absoluteString];
             completion(downloadedItem);
         }
    }];
    [downloadTask resume];
}

- (UIImage *)cachedImageForKey:(NSString *)cacheid{
    __block UIImage *result = nil;
    [self.imageCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:cacheid]) {
            
            result =  [UIImage imageWithData:obj];
            *stop = YES;
        }
    }];
    return result;
}


@end
