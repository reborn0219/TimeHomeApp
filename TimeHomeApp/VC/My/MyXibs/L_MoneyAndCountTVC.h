//
//  L_MoneyAndCountTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TwoButtonClickCallBack)(NSInteger index);
/**
 余额和积分
 */
@interface L_MoneyAndCountTVC : UITableViewCell

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**
 积分
 */
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, copy) TwoButtonClickCallBack twoButtonClickCallBack;

@end
