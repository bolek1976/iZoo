//
//  ZooWebService.h
//  iZoo
//
//  Created by Boris Chirino on 18/11/15.
//  Copyright © 2015  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZooWebService : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property NSMutableDictionary *imageCache;

+ (instancetype) sharedInstance;
/**
 *  Retrieve all animals via HTTP GET method, using NSURLSession class. On response without error the returned json is
 *  parsed using NSJSONSerialization, if an error occur during serializaion the completion parameter send the error causing
 *  the issue. If any network problem occur the block parameter send this error. for mor info see parameter description
 *
 *  @param completion the response object obtained on success request
 *  @param failure    failure from network or parsing the response object
 */
- (void)getAllAnimalsCompletionSuccess:(void(^)(id response))completion failure:( void(^)(NSError *response))failure;



/**
 *  Download the image that url parameter is pointing to. If the download is successfull the image is cached on memory
 *  for subsequent request to the same file (Theoretically file will never change). The image is cached using the url as
 *  identifier for the image
 *
 *  @param url        url of the resource
 *  @param completion a block containing the image as NSData for later proccessing
 */
- (void)downloadImageFromURL:(NSURL*)url completion:(void(^)(id response))completion;



/**
 *  Return the image asociated with the key
 *
 *  @param cacheid Key used to store/retrieve the image. This parameter consist of the absoluteString url.
 *
 *  @return The image associated.
 */
- (UIImage* )cachedImageForKey:(NSString*)cacheid;
@end
