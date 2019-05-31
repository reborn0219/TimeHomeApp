//
//  L_GarageDaysPopVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DaysConfirmButtonCallBack)(NSString *days);
@interface L_GarageDaysPopVC : BaseViewController

@property (nonatomic, copy) DaysConfirmButtonCallBack daysConfirmButtonCallBack;

/**
 背景view
 */
@property (weak, nonatomic) IBOutlet UIView *dayBgView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  返回实例
 */
+ (L_GarageDaysPopVC *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withDay:(NSString *)days cellEvent:(DaysConfirmButtonCallBack)eventCallBack;

@end
