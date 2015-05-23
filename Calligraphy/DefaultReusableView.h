//
//  DefaultReusableView.h
//  Calligraphy
//
//  Created by Lin on 15/5/23.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DefaultReusableViewDelegate <NSObject>

- (void)didReusableViewIndexPath:(NSIndexPath *)aIndexPath;

@end

@interface DefaultReusableView : UICollectionReusableView

@property (nonatomic, assign) id<DefaultReusableViewDelegate> deletage;

@property (nonatomic, assign) NSIndexPath * indexPath;

@end

