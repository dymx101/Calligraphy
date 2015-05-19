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

/**
 *  数据转换成中文
 */
+ (NSString *)encodingGBKFromData:(id)aData;
/**
 *  中文转换成GBK码
 */
+ (NSString *)encodingBKStr:(NSString *)aStr;


+ (NSURLSessionDataTask *) get:(NSString *)aUrl
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
