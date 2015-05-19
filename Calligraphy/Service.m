//
//  Service.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Service.h"

static NSString * const kBaseURLString = @"http://shufa.m.supfree.net/raky.asp?zi=%B5%DB";

@implementation Service

+ (instancetype)sharedClient {
    static Service *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Service alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //申明返回的结果是json类型
//        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
//        
//        _sharedClient.requestSerializer=[AFHTTPRequestSerializer serializer];
    });
    
    return _sharedClient;
}


+ (NSURLSessionDataTask *) get:(NSString *)aUrl
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    NSLog(@"asdf:");
    
    return [[Service sharedClient] GET:aUrl
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   NSLog(@"%s:%@",__func__,responseObject);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   
                               }];
    
    
}



@end
