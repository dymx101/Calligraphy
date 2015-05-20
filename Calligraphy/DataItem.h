//
//  DataItem.h
//  Calligraphy
//
//  Created by QiMENG on 15/5/20.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject

@property (nonatomic, copy) NSString * typestr;     //书法类型
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imgurlstr;   //图片链接
@property (nonatomic, copy) NSString * author;      // 作者
@property (nonatomic, copy) NSString * authorurl;      // 作者链接


@property (nonatomic, retain) NSMutableArray * subArray;

+ (id)itemFromData:(id)aData;

@end
