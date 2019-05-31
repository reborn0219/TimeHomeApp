//
//  OBDShowAlertVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDShowAlertVC : UIViewController

/**
 *背景View
 **/
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 *上方红色背景view
 **/
@property (weak, nonatomic) IBOutlet UIView *topBgView;

/**
 *上方titleLabel
 **/
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSecondLabel;

/**
 *展示详情label
 **/
@property (weak, nonatomic) IBOutlet UITextView *showDetailLabel;

/**
 *分割线view
 **/
@property (weak, nonatomic) IBOutlet UIView *lineView;

/**
 *返回按钮和view
 **/
@property (weak, nonatomic) IBOutlet UIImageView *backView;
;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

/**
 *上一页按钮和view
 **/
@property (weak, nonatomic) IBOutlet UIImageView *lastView;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;

/**
 *下一个
 **/
@property (weak, nonatomic) IBOutlet UIImageView *nextView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


/**
 *  获取实例
 *
 *  @return return value description
 */
+(OBDShowAlertVC *)getInstance;

+(instancetype)shareOBDShowAlert;
@property (nonatomic,copy)ViewsEventBlock block;


-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andSecondTitle:(NSString *)secondTitle andShowDetailLabelText:(NSString *)showDetailLabelText;
-(void)dismiss;

@end
