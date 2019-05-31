//
//  L_PointRuleShowViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_PointRuleShowViewController : UIViewController

/**
 *  返回实例
 */
+ (L_PointRuleShowViewController *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withString:(NSString *)string;

@end
