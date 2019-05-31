//
//  THInputView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^ DateButtonClickCallBack)(BOOL buttonSelected);

@interface THInputView : UIView

/**
 *  左边标题
 */
@property (nonatomic, strong) UILabel *leftTitleLabel;
/**
 *  选择日期label
 */
@property (nonatomic, strong) UILabel *buttonTitleLabel;
/**
 *  选择日期回调
 */
//@property (nonatomic, copy) DateButtonClickCallBack dateButtonClickCallBack;
/**
 *  时间选择按钮,默认隐藏
 */
@property (nonatomic, strong) UIButton *dateSelectButton;

@end
