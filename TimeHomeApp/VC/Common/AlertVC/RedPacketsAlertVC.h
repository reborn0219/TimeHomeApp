//
//  RedPacketsAlertVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface RedPacketsAlertVC : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *nickeLb;
@property (weak, nonatomic) IBOutlet UILabel *redMsgLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtn_layout_top;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UIView *headerV;

/**
 点击跳转到红包详情页面

 @param sender 按钮
 */
- (IBAction)checkBtnAction:(id)sender;
- (IBAction)closeBtnAction:(id)sender;

/**
 初始化

 @return self
 */
+(instancetype)shareRedPacketsAlert;
@property (nonatomic,copy)ViewsEventBlock block;
-(void)showInVC:(UIViewController *)VC with:(NSDictionary *)dic;
-(void)dismiss;
@end
