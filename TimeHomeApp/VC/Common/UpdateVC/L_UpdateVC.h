//
//  L_UpdateVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_UpdateVC : UIViewController

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;
//1.隐藏下方按钮
@property (nonatomic, assign) int type;

/**
 版本号 V2.5.2
 */
@property (weak, nonatomic) IBOutlet UILabel *version_Label;

/**
 立即升级
 */
@property (weak, nonatomic) IBOutlet UIButton *update_Button;

+ (L_UpdateVC *)getInstance;

- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg withVersion:(NSString *)version cellEvent:(ViewsEventBlock)eventCallBack;

@end
