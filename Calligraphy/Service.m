//
//  Service.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Service.h"

static NSString * const kBaseURLString = @"http://shufa.m.supfree.net/";

@implementation Service

+ (instancetype)sharedClient {
    static Service *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Service alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //申明返回的结果是json类型
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sharedClient.requestSerializer=[AFHTTPRequestSerializer serializer];
    });
    
    return _sharedClient;
}
#pragma mark - 数据转换成中文
+ (NSString *)encodingGBKFromData:(id)aData {
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [[NSString alloc] initWithData:aData encoding:gbkEncoding];
    return string;
}
#pragma mark - 中文转换成GBK码
+ (NSString *)encodingBKStr:(NSString *)aStr {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    aStr = [aStr stringByAddingPercentEscapesUsingEncoding:enc];
    return aStr;
}


+ (NSURLSessionDataTask *) get:(NSString *)aUrl
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    
    return [[Service sharedClient] GET:aUrl
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSString * responseString = [self encodingGBKFromData:responseObject];
                                   
                                   
                                   NSLog(@"%@",responseString);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"%@",error);
                               }];
}


@end
