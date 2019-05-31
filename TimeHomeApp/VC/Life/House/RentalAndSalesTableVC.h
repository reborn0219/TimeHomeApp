//
//  RentalAndSalesTableVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  求租、求售列表
 */
#import "BaseViewController.h"

@interface RentalAndSalesTableVC : THBaseViewController
///0.房屋求租 1.房屋求售 2.车位求租 3.车位求售  4.车位出租 5.车位出售
@property(nonatomic,assign)int jmpCode;

///是否是从发布页过来的 YES 是
@property(nonatomic,assign) BOOL isFromeRelease;

@end
