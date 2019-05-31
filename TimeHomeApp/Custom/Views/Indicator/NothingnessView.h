//
//  NothingnessView.h
//  TimeHomeApp
//
//  Created by us on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckButtonCallBack)();

@interface NothingnessView : UIView

@property (nonatomic, copy) CheckButtonCallBack checkButtonCallBack;
/**
 查看已失效券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labCluesCenter;

/**
 *  错误图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_ErrorIcon;
/**
 *  提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Clues;
/**
 *  子提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_subClues;
/**
 *  用于隐藏副提示语和Button
 */
@property (weak, nonatomic) IBOutlet UIView *view_SubBg;

/**
 *  按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Go;

///事件处理
@property(nonatomic,copy) ViewsEventBlock eventCallBack;

/**
 *  获取实例
 *
 *  @return
 */
+(NothingnessView *)getInstanceView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerH;

@end
