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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString * str = @"帝";
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
    
//    NSURL * url = [NSURL ];
    
    
    
    [Service get:@"" parameters:nil withBlock:^(NSArray *posts, NSError *error) {
       
        
    }];
    
//    [QMService qm_RegistPostDic:@{@"mobile": @"18813863261",
//                                  @"device":@"11111111111111"}
//                      withBlock:^(NSDictionary *aDic, NSError *error) {
//                          //todo...
//                      }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
