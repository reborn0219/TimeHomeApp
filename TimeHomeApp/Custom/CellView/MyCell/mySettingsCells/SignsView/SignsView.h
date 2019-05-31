//
//  SignsView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *  TextView输入框
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>
#import "THPlaceHolderTextView.h"

typedef void (^CallBack)(void);
@interface SignsView : UIView <UITextViewDelegate>
/**
 *  输入框
 */
@property (nonatomic, strong) THPlaceHolderTextView *signTextView;
///**
// *  输入字数最大限制,默认为0
// */
//@property (nonatomic, assign) NSInteger masLimitCount;
/**
 *  右下角显示字数的label,默认显示
 */
@property (nonatomic, strong) UILabel *countsLabel;
/**
 *  删除按钮
 */
@property (nonatomic, strong) UIButton *cancel_Button;

@property (nonatomic, copy) CallBack callBack;

@end
