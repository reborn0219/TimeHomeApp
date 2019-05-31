//
//  L_PopAlertView3.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_PopAlertView3 : UIViewController

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UIButton *first_Btn;
@property (weak, nonatomic) IBOutlet UIButton *second_Btn;
@property (weak, nonatomic) IBOutlet UIButton *third_Btn;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;


+ (L_PopAlertView3 *)getInstance;

- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack;
@end
