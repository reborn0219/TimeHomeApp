//
//  BaseViewController+RedBag.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/1.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController+RedBag.h"
#import "PARedBagView.h"
#import "PARedBagPresenter.h"
#import "PARedBagDetailViewController.h"
#import "PAVoucherTableViewController.h"
#import "PARedBagDetailModel.h"

@implementation BaseViewController (RedBag)

- (void)showRedBag:(PARedBagModel*)redBag{
    
    [PARedBagView showWithRedBag:redBag EventBlock:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
        if (index == 0) {//拆包
            PARedBagModel *redBag = data;
            [self openRedBag:redBag];//领取红包
        }else{//关闭
            [self showToastMsg:@"请到\"我的-我的红包\"领取" Duration:3.0f];
        }
    }];
}

- (void)openRedBag:(PARedBagModel*)redBag{
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [PARedBagPresenter receiveRedEnvelopeWithOrderId:redBag.orderid
                                        Userticketid:redBag.userticketid
                                          updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode == SucceedCode) {
                
                if (data) {
                    
                    NSArray *redBagArray = data;
                    
                    PARedBagDetailModel *redBag = redBagArray.firstObject;
                    if(redBag.type == 0){//红包
                        
                        PARedBagDetailViewController *redBagDetailVC = [[PARedBagDetailViewController alloc]initWithNibName:@"PARedBagDetailViewController" bundle:nil];
                        redBagDetailVC.redBag = redBag;
                        [self.navigationController pushViewController:redBagDetailVC animated:YES];
                        
                    }else{//优惠券
                        
                        [self showToastMsg:@"领取成功,请到\"我的-我的票券\"查看" Duration:3.0f];
                        
                        PAVoucherTableViewController *voucherVC = [[PAVoucherTableViewController alloc]initWithNibName:@"PAVoucherTableViewController" bundle:nil];
                        voucherVC.redBagArray = redBagArray;
                        [self.navigationController pushViewController:voucherVC animated:YES];
                    }
                }
            }else {
                //失败
                if ([data isKindOfClass:[NSString class]]) {
                    [self showToastMsg:data Duration:3.0f];
                }else {
                    [self showToastMsg:[XYString IsNotNull:data[@"msg"]] Duration:3.0f];
                }
            }
        });
    }];
}

@end
