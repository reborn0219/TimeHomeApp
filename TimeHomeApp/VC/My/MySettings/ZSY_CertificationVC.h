//
//  ZSY_CertificationVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/9/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 * 实名认证页面
 **/
#import "THBaseViewController.h"

@interface ZSY_CertificationVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *showPicButton;
@property (nonatomic,copy)NSString *IDStr; //用于检测上级页面
@property (nonatomic,assign)NSString *certificationState; //认证状态
@end
