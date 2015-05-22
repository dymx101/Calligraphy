//
//  DataItem.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/20.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subArray = [NSMutableArray array];
    }
    return self;
}

- (void)setImgurlstr:(NSString *)imgurlstr {
    
    _imgurlstr = [NSString stringWithFormat:@"%@%@",kBaseURLString,imgurlstr];
    
}
- (void)setTypestr:(NSString *)typestr {
    _typestr = [typestr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _typestr = [_typestr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}

+ (id)itemFromData:(id)aData {
    
    DataItem * item = [[DataItem alloc]init];
    
    
    
    return item;
}


@end
