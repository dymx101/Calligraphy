//
//  UserData.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/25.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (void)setiAPClear{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPClear];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)iAPClear {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIAPClear]) {
        return YES;
    }
    return NO;
}


@end
