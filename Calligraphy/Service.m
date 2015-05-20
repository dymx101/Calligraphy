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
+ (NSURLSessionDataTask *) DefaultTextAndAuthor:(void (^)(NSDictionary *dic, NSError *error))block{
    
    return [[Service sharedClient] GET:@"index.asp"
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   block([self makeDictionaryFrom:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   block(nil, error);
                               }];
    
    return nil;
}
+ (NSDictionary *)makeDictionaryFrom:(id)aData {
    
//    NSLog(@"%@",[self encodingGBKFromData:aData]);
    
    @autoreleasepool {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:aData
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            
            NSArray *textList = [doc nodesForXPath:@"//div[@class='cdiv wenk']" error:NULL];

            for (GDataXMLElement * elements in textList) {
                
//                NSLog(@"%@",elements.stringValue);
                
                NSLog(@"%@",[[elements attributeForName:@"title"] stringValue]);
            }
            
            NSArray *authorList = [doc nodesForXPath:@"//div[@class='cdiv']" error:NULL];
            
            for (GDataXMLElement * elements in authorList) {
                
                NSLog(@"%@",elements.stringValue);
                
//                NSLog(@"%@",[[elements attributeForName:@"title"] stringValue]);
            }
        }
    }
    
    
    
    return nil;
}




/**
 *  获取page 文字
 */
+ (NSURLSessionDataTask *) TextPage:(NSInteger)aPage
                          withBlock:(void (^)(NSArray *array, NSError *error))block{
    return nil;
}

/**
 *  获取书法家列表
 */
+ (NSURLSessionDataTask *) AllAuthor:(void (^)(NSArray *array, NSError *error))block{
    return nil;
}

#pragma mark - 搜索书法家
+ (NSURLSessionDataTask *) SearchAuthor:(NSString *)aSearch
                             parameters:(id)parameters
                              withBlock:(void (^)(NSArray *posts, NSError *error))block{
    return nil;
}

#pragma mark - 搜索文字
+ (NSURLSessionDataTask *) SearchText:(NSString *)aSearch
                    parameters:(id)parameters
                     withBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    return [[Service sharedClient] GET:aSearch
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
                    
                    //具体图片
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


@end
