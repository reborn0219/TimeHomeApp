//
//  RaiN_NewRegisterVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface RaiN_NewRegisterVC : BaseViewController

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**
 注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,copy)NSString *thePhoneNumber;//未注册时传的手机号 有则赋值，否则不做处理

@end
