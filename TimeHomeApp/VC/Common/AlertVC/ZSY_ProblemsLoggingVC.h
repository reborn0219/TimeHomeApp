//
//  ZSY_ProblemsLoggingVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_ProblemsLoggingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**
 *  获取实例
 *
 *  @return return value description
 */
//+(ZSY_ProblemsLoggingVC *)getInstance;

+(instancetype)shareProblemsLoggingVC;
@property (nonatomic,copy)ViewsEventBlock block;


-(void)show:(UIViewController * )VC;
-(void)dismiss;
@end
