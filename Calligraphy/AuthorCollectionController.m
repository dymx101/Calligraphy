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
@interface AuthorCollectionController ()

@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation AuthorCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _selectItem.author;
    _dataArray = [NSMutableArray array];
    
    
    [Service CalligraphyFromAuthor:_selectItem.authorurl
                         withBlock:^(NSArray *posts, NSError *error) {
                             
                             _dataArray = [NSMutableArray arrayWithArray:posts];
                             [self.collectionView reloadData];

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
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    
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


@end
