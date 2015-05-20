//
//  ViewController.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "ViewController.h"
#import "Service.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取默认页
    [Service DefaultTextAndAuthor:^(NSDictionary *dic, NSError *error) {
        
    }];
    
    
    
    //搜索
    NSString * str = @"raky.asp?zi=帝";
    
    [Service SearchText:[Service encodingBKStr:str] parameters:nil withBlock:^(NSArray *posts, NSError *error) {

        [_dataArray addObjectsFromArray:posts];
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
