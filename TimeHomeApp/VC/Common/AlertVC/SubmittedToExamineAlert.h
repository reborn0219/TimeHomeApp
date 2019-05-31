//
//  SubmittedToExamineAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface SubmittedToExamineAlert : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UILabel *msglabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelCenterLayout; // -10  -30
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *checkMyHouseBtn;


+(instancetype)shareNewAlert;

-(void)showInVC:(UIViewController *)VC;

@property (nonatomic,copy)ViewsEventBlock block;
@property(nonatomic,assign)BOOL isHiddenBtn;//是否隐藏下方按钮
-(void)dismiss;

/**
 *  返回实例
 */
+ (SubmittedToExamineAlert *)getInstance;

@end
