//
//  DefaultReusableView.m
//  Calligraphy
//
//  Created by Lin on 15/5/23.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "DefaultReusableView.h"

@implementation DefaultReusableView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_deletage && [_deletage respondsToSelector:@selector(didReusableViewIndexPath:)]) {
        [_deletage didReusableViewIndexPath:_indexPath];
    }
    
}

@end
