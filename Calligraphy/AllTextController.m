//
//  AllTextController.m
//  Calligraphy
//
//  Created by Lin on 15/5/23.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "AllTextController.h"
#import "Service.h"

#import "TextCollectionController.h"
@interface AllTextController () {
    
    NSInteger pageInt;
    

}
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation AllTextController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageInt = 1;
    
    _dataArray = [NSMutableArray array];
    [Service AllTextPage:pageInt withBlock:^(NSArray *array, NSError *error) {
        [_dataArray addObjectsFromArray:array];
        
        [self.collectionView reloadData];
        
    }];
    
    
    int a = arc4random()%10;
    if (a>4) {
        [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DataItem * item = _dataArray[indexPath.row];
    
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = item.title;
    titleLabel.font = [UIFont systemFontOfSize:30];
    // Configure the cell
    
        cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [UIColor blackColor].CGColor ;
    cell.layer.borderWidth = 1;
//    float colorRed = (float)indexPath.row/_dataArray.count;
//    cell.backgroundColor = [UIColor colorWithRed:colorRed+0.0 green:colorRed+0.3 blue:colorRed+0.6 alpha:1.0f];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DataItem * item = _dataArray[indexPath.row];
    
    if (indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"TextCollectionController" sender:item.title];
        
    }else {
        [self performSegueWithIdentifier:@"AuthorCollectionController" sender:item];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"TextCollectionController"]) {
        TextCollectionController *ctrl = segue.destinationViewController;
        ctrl.searchStr = sender;
    }

}


#pragma mark <UICollectionViewDelegate>
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DataItem * item = _dataArray[indexPath.row];
    
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:30]};
    CGSize textSize = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    
    return CGSizeMake(ceilf(textSize.height), ceilf(textSize.height));
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10, 10);
}

- (IBAction)touchMore:(UIButton *)sender {
    
    sender.enabled = NO;
    [Service AllTextPage:++pageInt withBlock:^(NSArray *array, NSError *error) {
        
        if (_dataArray.count < 240-1) {
            return;
        }
        
        [_dataArray addObjectsFromArray:array];
        [self.collectionView reloadData];
        
        if (array.count == 240) {
            sender.enabled = YES;
        }

    }];
    
}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];

        reusableview = headerView;
        
    }
    return reusableview;
    
}

@end
