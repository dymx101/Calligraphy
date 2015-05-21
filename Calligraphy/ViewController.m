//
//  ViewController.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/19.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "ViewController.h"
#import "Service.h"
#import "TextCollectionController.h"
@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollection;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

static NSString * const reuseIdentifier = @"GradientCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _dataArray = [NSMutableArray array];
    
    //获取默认页
    [Service DefaultTextAndAuthor:^(NSMutableArray *array, NSError *error) {
        
        [_dataArray addObjectsFromArray:array];
        
        [_mainCollection reloadData];
    }];
    
    
    
    [Service AllAuthor:^(NSArray *array, NSError *error) {
        
    }];

}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_dataArray[section]).count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];
    
    if (item.author) {
        titleLabel.text = item.author;
        titleLabel.font = [UIFont systemFontOfSize:16];
    }else {
        titleLabel.text = item.title;
        titleLabel.font = [UIFont systemFontOfSize:30];
    }

    float colorRed = (float)indexPath.row/((NSArray *)_dataArray[indexPath.section]).count;
    
//    NSLog(@"%f",colorRed);
//    cell.backgroundColor = [UIColor colorWithRed:1.0 green:10*indexPath.row/255.0 blue:10*indexPath.row/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:colorRed green:colorRed blue:colorRed alpha:1.0f];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];
    
    if (item.author) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGSize textSize = [item.author boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
        
        return CGSizeMake(ceilf(textSize.width)+5, ceilf(textSize.height));
    }else {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:30]};
        CGSize textSize = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
        
        return CGSizeMake(ceilf(textSize.height), ceilf(textSize.height));
    }
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

        UILabel * titleLable = (UILabel *)[headerView viewWithTag:100];
        
        if (!titleLable) {
            titleLable = [[UILabel alloc]initWithFrame:headerView.bounds];
            [headerView addSubview:titleLable];
        }
        
        switch (indexPath.section) {
            case 0:
                titleLable.text  = @"文字列表";
                break;
            default:
                titleLable.text  = @"书法家列表";
                break;
        }
        
        reusableview = headerView;
        
    }
    return reusableview;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];
    
    if (indexPath.section == 0) {
     
        [self performSegueWithIdentifier:@"TextCollectionController" sender:item.title];
        
    }else {
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"TextCollectionController"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        TextCollectionController *ctrl = segue.destinationViewController;
        ctrl.searchStr = sender;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
