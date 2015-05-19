//
//  Service.h
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

@interface Service : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSURLSessionDataTask *) get:(NSString *)aUrl
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
