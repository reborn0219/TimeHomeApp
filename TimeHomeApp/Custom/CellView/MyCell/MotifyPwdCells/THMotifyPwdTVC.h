//
//  THMotifyPwdTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "CustomTextFIeld.h"

typedef NS_ENUM(NSInteger, RightControlStyle) {
    /**
     *  右边控件为输入框
     */
    RightControlStyleTextField = 0,
    /**
     *  右边控件为label
     */
    RightControlStyleLabel = 1,
};

@interface THMotifyPwdTVC : THABaseTableViewCell
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImageView *leftImage;
/**
 *  右边输入框
 */
@property (nonatomic, strong) CustomTextFIeld *rightTextField;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  右边控件类型
 */
@property (nonatomic, assign)  RightControlStyle rightControlStyle;

@end
