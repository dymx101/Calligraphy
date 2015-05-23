//
//  Service.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Service.h"

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
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    [SVProgressHUD showErrorWithStatus:@"已链接wifi"];
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已链接wifi" message:nil delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    [SVProgressHUD showErrorWithStatus:@"网络中断.请检查网络设置."];
                }
                    break;
                default:
                    break;
            }
        }];
        
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
                                   
                                   block([self parseFromDefault:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSMutableArray *)parseFromDefault:(id)aData {
    
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
+ (NSURLSessionDataTask *) AllTextPage:(NSInteger)aPage
                          withBlock:(void (^)(NSArray *array, NSError *error))block{
    
    NSLog(@"%@",[NSString stringWithFormat:@"dity.asp?page=%ld",(long)aPage]);
    
    return [[Service sharedClient] GET:[NSString stringWithFormat:@"dity.asp?page=%ld",(long)aPage]
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self parseFromText:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
    return nil;
}
+ (NSArray *)parseFromText:(id)aData {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    @autoreleasepool {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            {   //默认的文字
                NSArray *textList = [doc nodesForXPath:@"//div[@class='cdiv wenk']" error:NULL];
                
                for (GDataXMLElement * elements in textList) {
                    
                    NSArray *agroups = [elements elementsForName:@"a"];
                    for (GDataXMLElement *element  in agroups) {
                        
                        DataItem * subItem = [DataItem new];
                        [mainArray addObject:subItem];
                        
                        subItem.title = element.stringValue;
                        subItem.authorurl = [[element attributeForName:@"href"] stringValue];
                        
                    }
                    
                }
            }
        }
    }
    
    return mainArray;
}

#pragma mark - 获取书法家列表
+ (NSURLSessionDataTask *) AllAuthor:(void (^)(NSDictionary *dic, NSError *error))block{
    return [[Service sharedClient] GET:@"widy.asp"
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self parseFromAllAuthor:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}

+ (NSDictionary *)parseFromAllAuthor:(id)aData {
    
    //    NSLog(@"%@",[self encodingGBKFromData:aData]);
    
    NSMutableDictionary * mainDic = [NSMutableDictionary dictionary];
    
    @autoreleasepool {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            NSArray *list = [doc nodesForXPath:@"//div[@class='cdiv']" error:NULL];
            
            for (GDataXMLElement * elements in list) {
                
                NSArray *p = [elements elementsForName:@"p"];
                if (p.count > 0) {
                    
                    for (GDataXMLElement * item in p) {
                        NSString * key = @"";
                        {
                            NSArray *span = [item elementsForName:@"span"];
                            if (span) {
                                GDataXMLElement *firstName = (GDataXMLElement *) [span objectAtIndex:0];
                                key = firstName.stringValue;
                            }else {
                                continue;
                            }
                        }
                        NSMutableArray * objectArray = [NSMutableArray array];
                        NSArray *arrays = [item elementsForName:@"a"];
                        for (GDataXMLElement * e in arrays) {
                            DataItem * item = [DataItem new];
                            [objectArray addObject:item];
                            
                            item.author = e.stringValue;
                            item.authorurl = [[e attributeForName:@"href"] stringValue];
                        }
                        
                        [mainDic setObject:objectArray forKey:key];
                        
                    }
                }
            }
        }
    }
    
    return mainDic;
}


#pragma mark - 书法家的全部书法
+ (NSURLSessionDataTask *) CalligraphyFromAuthor:(NSString *)aSearch
                                            page:(NSInteger)aPage
                                       withBlock:(void (^)(NSArray *posts, NSError *error))block{
    
    return [[Service sharedClient] GET:[NSString stringWithFormat:@"%@&page=%ld",aSearch,(long)aPage]
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self parseFromAuthorData:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSArray *)parseFromAuthorData:(id)aData {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    @autoreleasepool {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            NSArray *list = [doc nodesForXPath:@"//div[@class='cdiv']" error:NULL];
            
            for (GDataXMLElement * elements in list) {
                
                
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
                                subItem.imgurlstr = [[element attributeForName:@"href"] stringValue];
                            }
                        }
                        [mainArray addObject:subItem];
                    }
                }
                //                    [mainArray addObject:mainItem];
            }
            
        }
    }
    
    return mainArray;
}





#pragma mark - 搜索文字
+ (NSURLSessionDataTask *) SearchText:(NSString *)aSearch
                           parameters:(id)parameters
                            withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    
    
    return [[Service sharedClient] GET:[Service encodingBKStr:[NSString stringWithFormat:@"raky.asp?zi=%@",aSearch]]
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self parseFromTextData:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
/**
 *  解析数据列表 @{ DataItem }
 */
+ (NSArray *)parseFromTextData:(id)aData {
    
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
                                    subItem.imgurlstr = [[element attributeForName:@"href"] stringValue];
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
                                   
//                                   block([self parseFromTextData:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   block(nil, error);
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}


@end
