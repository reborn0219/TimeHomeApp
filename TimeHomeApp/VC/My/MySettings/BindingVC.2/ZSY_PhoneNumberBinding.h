//
//  ZSY_PhoneNumberBinding.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 手机号绑定页面
 */
#import "THBaseViewController.h"

@interface ZSY_PhoneNumberBinding : THBaseViewController
/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *captchaCodTF;
/**
 收不到验证码
 */
@property (weak, nonatomic) IBOutlet UIButton *DoNotGetButton;
/**
 绑定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;
/**
 发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *fasong;
@property (weak, nonatomic) IBOutlet UIView *phoneNumberBGView;
@property (weak, nonatomic) IBOutlet UIView *codTfBgView;

/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password_TF;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;

/**
 用于检测上级页面
 */
@property (nonatomic,copy)NSString *IDStr;
/**
 第三方类型
 */
@property (nonatomic,copy)NSString *type;
/**
 第三方昵称
 */
@property (nonatomic,copy)NSString *thirdName;
/**
 第三方令牌
 */
@property (nonatomic,copy)NSString *thirdToken;
/**
 第三方ID
 */
@property (nonatomic,copy)NSString *thirdID;
@end
