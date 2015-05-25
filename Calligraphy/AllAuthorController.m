//
//  AllAuthorController.m
//  Calligraphy
//
//  Created by Lin on 15/5/23.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "AllAuthorController.h"
#import "Service.h"
#import "AuthorCollectionController.h"
#define kAlphaOrder @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@interface AllAuthorController ()
@property (nonatomic, strong) NSDictionary * dataDic;
@end

@implementation AllAuthorController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataDic = [NSDictionary dictionary];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [Service AllAuthor:^(NSDictionary *dic, NSError *error) {
        _dataDic = dic;
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _dataDic.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSString * key = [kAlphaOrder substringWithRange:NSMakeRange(section, 1)];
    
    
    return ((NSArray *)_dataDic[key]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString * key = [kAlphaOrder substringWithRange:NSMakeRange(indexPath.section, 1)];
    
    DataItem * item = ((NSArray *)_dataDic[key])[indexPath.row];
    
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    
    //    cell.backgroundColor = [UIColor colorWithRed:(1-(5 * indexPath.row) / 255.0) green:(1-(10 * indexPath.row)/255.0) blue:(1-(15 * indexPath.row)/255.0) alpha:1.0f];
    
//    float colorRed = 0.5;
//    cell.backgroundColor = [UIColor colorWithRed:colorRed+0.0 green:colorRed+0.3 blue:colorRed+0.6 alpha:1.0f];

    cell.layer.borderColor = [UIColor blackColor].CGColor ;
    cell.layer.borderWidth = 1;
    cell.layer.masksToBounds = YES;

    titleLabel.text = item.author;
    titleLabel.font = [UIFont systemFontOfSize:18];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [kAlphaOrder substringWithRange:NSMakeRange(indexPath.section, 1)];
    
    DataItem * item = ((NSArray *)_dataDic[key])[indexPath.row];
    

        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
        CGSize textSize = [item.author boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
        
        return CGSizeMake(ceilf(textSize.width)+5, ceilf(textSize.height));

}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UILabel * label = (UILabel *)[headerView viewWithTag:100];
        
        
        NSString * key = [kAlphaOrder substringWithRange:NSMakeRange(indexPath.section, 1)];
        
        label.text = key;
        
        
        reusableview = headerView;
        
    }
    return reusableview;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * key = [kAlphaOrder substringWithRange:NSMakeRange(indexPath.section, 1)];
    
    DataItem * item = ((NSArray *)_dataDic[key])[indexPath.row];
    

    [self performSegueWithIdentifier:@"AuthorCollectionController" sender:item];

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"AuthorCollectionController"]) {
        AuthorCollectionController *ctrl = segue.destinationViewController;
        ctrl.selectItem = sender;
    }
}


@end
