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
                                   
                                   block([self listFromData:responseObject], nil);
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"%@",error);
                               }];
}

+ (NSArray *)listFromData:(id)aData {
    
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
