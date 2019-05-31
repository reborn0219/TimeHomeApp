//
//  L_PopAlertView4.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_PopAlertView4 : UIViewController

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UIButton *left_Btn;
@property (weak, nonatomic) IBOutlet UIButton *right_Btn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;


+ (L_PopAlertView4 *)getInstance;

- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack;

@end
