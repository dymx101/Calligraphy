//
//  TextCollectionController.h
//  Calligraphy
//
//  Created by QiMENG on 15/5/21.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataItem;

@interface TextCollectionController : UICollectionViewController

@property (nonatomic, strong) DataItem * selectItem;

@property (nonatomic, copy) NSString * searchStr;

@end
