//
//  RaiN_BalanceAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 发帖余额弹窗
 */
#import <UIKit/UIKit.h>

@interface RaiN_BalanceAlert : THBaseViewController

/**
 可用余额
 */
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;

/**
 需要支付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;

/**
 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

/**
 关闭按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,copy) NSString *needPayStr;//需要支付的金额
@property (nonatomic,copy) NSString *canUseStr;//可用余额


@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)shareshowBalanceVC;
-(void)show:(UIViewController * )VC;
-(void)dismiss;
@end
