//
//  SetTableController.m
//  Calligraphy
//
//  Created by Lin on 15/5/24.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "SetTableController.h"
#import <UMSocial.h>
#import <SimplePurchase.h>
@interface SetTableController ()<UMSocialUIDelegate> {
    
    __weak IBOutlet UILabel *clearLabel;
    
    
    
}

@end

@implementation SetTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UserData iAPClear]) {
        clearLabel.text = @"回复购买";
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        //评论
        NSString *appURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        //分享
        
        NSString *appURL = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",kAppID];
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUMengKey
                                          shareText:appURL
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToEmail,UMShareToSms,UMShareToSina,UMShareToTencent,nil]
                                           delegate:self];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        
        [SimplePurchase buyProduct:kIAPClear block:^(NSError *error)
         {
             if (error)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Purchase Error"
                                             message:error.localizedDescription
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }else {
                 
                 [UserData setiAPClear];
                 clearLabel.text = @"回复购买";
             }
         }];
        
//        [SimplePurchase addObserverForProduct:kIAPClear
//                                        block:^(SKPaymentTransaction *transaction)
//        {
//            // the purchase has been made; make a record of it and perform whatever
//            // changes neccessary in the app.
//        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
