//
//  Service.h
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "DataItem.h"



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


/**
 *  默认初始页数据
 *
 *  @param block aDataDic = @[@"text":@{}, @"author":@{}]
 */
+ (NSURLSessionDataTask *) DefaultTextAndAuthor:(void (^)(NSMutableArray *array, NSError *error))block;

/**
 *  获取page 文字
 */
+ (NSURLSessionDataTask *) AllTextPage:(NSInteger)aPage
                             withBlock:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取书法家列表
 */
+ (NSURLSessionDataTask *) AllAuthor:(void (^)(NSDictionary *dic, NSError *error))block;


/**
 *  搜索文字
 */
+ (NSURLSessionDataTask *) SearchText:(NSString *)aSearch
                             parameters:(id)parameters
                              withBlock:(void (^)(NSArray *posts, NSError *error))block;

/**
 *  搜索书法家
 */
+ (NSURLSessionDataTask *) CalligraphyFromAuthor:(NSString *)aSearch
                                       withBlock:(void (^)(NSArray *posts, NSError *error))block;

/**
 *  根据书法家.搜索文字
 */
+ (NSURLSessionDataTask *) SearchText:(NSString *)aText AccordAuthor:(NSString *)aAuthor
                           parameters:(id)parameters
                            withBlock:(void (^)(NSArray *posts, NSError *error))block;



@end
