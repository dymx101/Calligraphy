//
//  AuthorCollectionController.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/21.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "AuthorCollectionController.h"
#import "Service.h"
#import <UIImageView+WebCache.h>
@interface AuthorCollectionController () {
    NSInteger pageInt;
}

@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation AuthorCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _selectItem.author;
    _dataArray = [NSMutableArray array];
    pageInt = 1;
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [Service CalligraphyFromAuthor:_selectItem.authorurl
                              page:pageInt
                         withBlock:^(NSArray *posts, NSError *error) {
                             
                             _dataArray = [NSMutableArray arrayWithArray:posts];
                             [self.collectionView reloadData];
                             
                             [SVProgressHUD dismiss];

                         }];
    
    if (![UserData iAPClear]) {
        int a = arc4random()%10;
        if (a>4) {
            [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
            }];
        }
    }

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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    DataItem * item = _dataArray[indexPath.row];
    
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:111];
    
    @autoreleasepool {
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imgurlstr] placeholderImage:nil];
    }
    
//    cell.backgroundColor = [UIColor colorWithRed:(1-(10 * indexPath.row) / 255.0) green:(1-(20 * indexPath.row)/255.0) blue:(1-(30 * indexPath.row)/255.0) alpha:1.0f];
//    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [UIColor blackColor].CGColor ;
    cell.layer.borderWidth = 1;
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10, 10);
}

- (IBAction)touchMore:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [Service CalligraphyFromAuthor:_selectItem.authorurl
                              page:++pageInt
                         withBlock:^(NSArray *posts, NSError *error) {
                             
                             [SVProgressHUD dismiss];
                             
                             if (_dataArray.count < 50-1) {
                                 
                                 [sender setTitle:@"没有更多了" forState:UIControlStateDisabled];
                                 
                                 return;
                             }
                             
                             [_dataArray addObjectsFromArray:posts];
                             [self.collectionView reloadData];
                             
                             if (posts.count ==50) {
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
