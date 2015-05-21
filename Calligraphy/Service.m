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

/**
 *  默认初始页数据
 *
 *  @param block aDataDic = @[@"text":@{}, @"author":@{}]
 */
+ (NSURLSessionDataTask *) DefaultTextAndAuthor:(void (^)(NSMutableArray *array, NSError *error))block{
    
    return [[Service sharedClient] GET:@"index.asp"
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self defaultTextAuthorFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
    
    return nil;
}
+ (NSMutableArray *)defaultTextAuthorFrom:(id)aData {
    
//    NSLog(@"%@",[self encodingGBKFromData:aData]);
    
    NSMutableArray * mainArray = [NSMutableArray arrayWithCapacity:2];
    
    @autoreleasepool {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            {   //默认的文字
                NSArray *textList = [doc nodesForXPath:@"//div[@class='cdiv wenk']" error:NULL];
                NSMutableArray * subArray = [NSMutableArray array];
                [mainArray addObject:subArray];
                
                for (GDataXMLElement * elements in textList) {
                    
                    NSArray *agroups = [elements elementsForName:@"a"];
                    for (GDataXMLElement *element  in agroups) {
                        
                        DataItem * subItem = [DataItem new];
                        [subArray addObject:subItem];
                        
                        subItem.title = element.stringValue;
                        subItem.authorurl = [[element attributeForName:@"href"] stringValue];
                        
                    }

                }
            }
            
            {   //默认的书法家
                NSArray *authorList = [doc nodesForXPath:@"//div[@class='cdiv']" error:NULL];
                
                NSMutableArray * subArray = [NSMutableArray array];
                [mainArray addObject:subArray];
                
                for (GDataXMLElement * elements in authorList) {
                    
                    NSArray *groups = [elements elementsForName:@"ul"];
                    for (GDataXMLElement * item in groups) {
                        NSArray *groups = [item elementsForName:@"li"];
                        for (GDataXMLElement * aItem in groups) {
                            
                            NSArray *agroups = [aItem elementsForName:@"a"];
                            for (GDataXMLElement *element  in agroups) {
                                
                                DataItem * subItem = [DataItem new];
                                [subArray addObject:subItem];
                                
                                subItem.author = [[element attributeForName:@"title"] stringValue];
                                subItem.authorurl = [[element attributeForName:@"href"] stringValue];
                                
                            }
                        }
                    }

                    
                }
            }
        }
    }
    
    return mainArray;
}




/**
 *  获取page 文字 列表
 */
+ (NSURLSessionDataTask *) TextPage:(NSInteger)aPage
                          withBlock:(void (^)(NSArray *array, NSError *error))block{
    
    return [[Service sharedClient] GET:[NSString stringWithFormat:@"dity.asp?page=%ld",aPage]
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
//                                   block([self makeDictionaryFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
    return nil;
}

/**
 *  获取书法家列表
 */
+ (NSURLSessionDataTask *) AllAuthor:(void (^)(NSArray *array, NSError *error))block{
    return [[Service sharedClient] GET:@"widy.asp"
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   //                                   block([self makeDictionaryFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
}

#pragma mark - 搜索书法家
+ (NSURLSessionDataTask *) SearchAuthor:(NSString *)aSearch
                             parameters:(id)parameters
                              withBlock:(void (^)(NSArray *posts, NSError *error))block{
    return [[Service sharedClient] GET:aSearch
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   //                                   block([self makeDictionaryFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
}

#pragma mark - 搜索文字
+ (NSURLSessionDataTask *) SearchText:(NSString *)aSearch
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    
    
    return [[Service sharedClient] GET:[Service encodingBKStr:[NSString stringWithFormat:@"raky.asp?zi=%@",aSearch]]
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self makeArrayFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
}
/**
 *  生成数据列表 @{ DataItem }
 */
+ (NSArray *)makeArrayFrom:(id)aData {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    @autoreleasepool {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            NSArray *list = [doc nodesForXPath:@"//div[@class='cdiv']" error:NULL];
            
            for (GDataXMLElement * elements in list) {

                NSArray *span = [elements elementsForName:@"span"];
                if (span.count > 0) {
                    
                    DataItem * mainItem = [DataItem new];
                    GDataXMLElement *firstName = (GDataXMLElement *) [span objectAtIndex:0];
                    mainItem.typestr = firstName.stringValue;
                    
                    NSArray *groups = [elements elementsForName:@"ul"];
                    for (GDataXMLElement * item in groups) {
                        NSArray *groups = [item elementsForName:@"li"];
                        for (GDataXMLElement * aItem in groups) {
                            DataItem * subItem = [DataItem new];
                            
                            NSArray *agroups = [aItem elementsForName:@"a"];
                            for (GDataXMLElement *element  in agroups) {
                                if ([element attributeForName:@"title"]) {
                                    subItem.title = element.stringValue;
                                    subItem.author = [[element attributeForName:@"title"] stringValue];
                                    subItem.authorurl = [[element attributeForName:@"href"] stringValue];
                                }else {
                                    subItem.imgurlstr = [NSString stringWithFormat:@"%@%@",kBaseURLString,[[element attributeForName:@"href"] stringValue]];
                                }
                            }
                            [mainItem.subArray addObject:subItem];
                        }
                    }
                    [mainArray addObject:mainItem];
                }

            }
        }
    }

    return mainArray;
}

#pragma mark - 根据书法家.搜索文字
+ (NSURLSessionDataTask *) SearchText:(NSString *)aText AccordAuthor:(NSString *)aAuthor
                           parameters:(id)parameters
                            withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
#warning
    return [[Service sharedClient] GET:aText
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self makeArrayFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
}


@end
