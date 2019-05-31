//
//  L_GivenPopVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectButtonCallBack)(NSInteger buttonIndex, NSString *context);

@interface L_GivenPopVC : BaseViewController

@property (nonatomic, copy) SelectButtonCallBack selectButtonCallBack;

/**
 *  返回实例
 */
+ (L_GivenPopVC *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withInfoDict:(NSDictionary *)dict cellEvent:(SelectButtonCallBack)eventCallBack;

/**
 隐藏
 */
- (void)dismissVC;

@end
