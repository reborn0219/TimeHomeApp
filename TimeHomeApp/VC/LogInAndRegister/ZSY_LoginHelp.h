//
//  ZSY_LoginHelp.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 登录页意见反馈
 */
#import "THBaseViewController.h"

@interface ZSY_LoginHelp : THBaseViewController
/**
 scrollerView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 textView
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIView *tfBgView;
/**
 提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
/**
 展示label
 */
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
/**
 手机型号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneType;
@property (weak, nonatomic) IBOutlet UIView *phoneTypeGbView;
/**
 用来模拟占位文字的textView
 */
@property (weak, nonatomic) IBOutlet UITextView *placeHolderTextView;

@end
