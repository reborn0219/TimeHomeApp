//
//  L_PopAlertView1.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_PopAlertView1 : UIViewController

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;
//1.隐藏下方按钮
@property (nonatomic, assign) int type;

+ (L_PopAlertView1 *)getInstance;

- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack;

@end
