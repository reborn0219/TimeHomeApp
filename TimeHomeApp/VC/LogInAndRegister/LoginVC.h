//
//  LoginVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 登录界面
 **/
#import "BaseViewController.h"

@interface LoginVC : BaseViewController
//view1 距上的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
//imageView的宽度
@property (weak, nonatomic) IBOutlet UIView *view1;


//登录按钮距上的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonTop;
//注册按钮距上的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonTop;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

///第三方登录

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight; //18
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height; //28
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;

///
@property (weak, nonatomic) IBOutlet UIView *leftlineVIew;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/**
 晚上
 */
@property (weak, nonatomic) IBOutlet UIView *eveningView;
@property (weak, nonatomic) IBOutlet UIImageView *leftStart;
@property (weak, nonatomic) IBOutlet UIImageView *leftStart1;
@property (weak, nonatomic) IBOutlet UIImageView *rightStrat;
@property (weak, nonatomic) IBOutlet UIImageView *rightStrat1;

/**
 白天
 */
@property (weak, nonatomic) IBOutlet UIView *daysView;
@property (weak, nonatomic) IBOutlet UIImageView *topCloud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCloudToLeft;

@property (weak, nonatomic) IBOutlet UIImageView *leftCloud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCloudToLeft;

@property (weak, nonatomic) IBOutlet UIImageView *rightCloud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCloudToRight;
@property (weak, nonatomic) IBOutlet UIImageView *loginLogo;


@end
