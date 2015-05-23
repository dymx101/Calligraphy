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
#import "AuthorCollectionController.h"
#import "DefaultReusableView.h"
@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,DefaultReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollection;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

static NSString * const reuseIdentifier = @"GradientCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    //获取默认页
    [Service DefaultTextAndAuthor:^(NSMutableArray *array, NSError *error) {
        
        [_dataArray addObjectsFromArray:array];
        
        [_mainCollection reloadData];
        
    }];

    
    

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_mainSearchBar setShowsCancelButton:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_mainSearchBar setShowsCancelButton:NO];
    [_mainSearchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    if (searchBar.text.length>1 || searchBar.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"请输入一个汉字"];
    }else {
        
        int a = [searchBar.text characterAtIndex:0];
        if( a > 0x4e00 && a < 0x9fff){
            [self performSegueWithIdentifier:@"TextCollectionController" sender:searchBar.text];
            
            [_mainSearchBar setShowsCancelButton:NO];
            [_mainSearchBar resignFirstResponder];

        }else {
            [SVProgressHUD showErrorWithStatus:@"请输入中文"];
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_dataArray[section]).count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
    
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];

    
//    cell.backgroundColor = [UIColor colorWithRed:(1-(5 * indexPath.row) / 255.0) green:(1-(10 * indexPath.row)/255.0) blue:(1-(15 * indexPath.row)/255.0) alpha:1.0f];
    
//    float colorRed = (float)indexPath.row/((NSArray *)_dataArray[indexPath.section]).count;
//    cell.backgroundColor = [UIColor colorWithRed:colorRed+0.0 green:colorRed+0.3 blue:colorRed+0.6 alpha:1.0f];
    
    if (item.author) {
        titleLabel.text = item.author;
        titleLabel.font = [UIFont systemFontOfSize:18];
    }else {
        titleLabel.text = item.title;
        titleLabel.font = [UIFont systemFontOfSize:30];
    }
    
    cell.layer.borderColor = [UIColor blackColor].CGColor ;
    cell.layer.borderWidth = 1;
    cell.layer.masksToBounds = YES;
//    cell.backgroundColor = [UIColor colorWithRed:(1-(10 * indexPath.row) / 255.0) green:(1-(20 * indexPath.row)/255.0) blue:(1-(30 * indexPath.row)/255.0) alpha:1.0f];

//    NSLog(@"%f",colorRed);
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];
    
    if (item.author) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
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
        
        DefaultReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DefaultReusableView" forIndexPath:indexPath];
        headerView.deletage = self;
        headerView.indexPath = indexPath;
        UILabel * titleLable = (UILabel *)[headerView viewWithTag:100];

        
        switch (indexPath.section) {
            case 0:
            {
                titleLable.text  = @"汉字列表";
            }
                break;
            default:
            {
                titleLable.text  = @"书法家列表";
            }
                break;
        }
        
        reusableview = headerView;
        
    }
    return reusableview;
    
}
- (void)didReusableViewIndexPath:(NSIndexPath *)aIndexPath {
    
    switch (aIndexPath.section) {
        case 0:
        {
            [self performSegueWithIdentifier:@"AllTextController" sender:self];
        }
            break;
        default:
        {
            [self performSegueWithIdentifier:@"AllAuthorController" sender:self];
        }
            break;
    }
    
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DataItem * item = ((NSArray *)_dataArray[indexPath.section])[indexPath.row];
    
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
    if ([segue.identifier isEqualToString:@"AuthorCollectionController"]) {
        AuthorCollectionController *ctrl = segue.destinationViewController;
        ctrl.selectItem = sender;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
