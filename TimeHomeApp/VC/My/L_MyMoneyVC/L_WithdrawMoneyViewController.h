//
//  L_WithdrawMoneyViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void(^RefreshListBlock)();

@interface L_WithdrawMoneyViewController : THBaseViewController

@property (nonatomic, copy) RefreshListBlock refreshListBlock;

/**
 微信openID
 */
@property (nonatomic, strong) NSString *openID;

@end
