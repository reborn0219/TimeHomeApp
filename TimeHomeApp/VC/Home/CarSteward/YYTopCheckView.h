//
//  YYTopCheckView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckButtonBlock)(UIButton *button);
/**
 *  检测view
 */
@interface YYTopCheckView : UIView

/**
 *  检测按钮
 */
@property (nonatomic, strong) UIButton *checkButton;

/**
 *  检测回调判断是否在检测中
 */
@property (nonatomic, copy) CheckButtonBlock checkButtonBlock;
/**
 *  车牌号
 */
@property (nonatomic, strong) UILabel *carNumbel_Label;

/**
 *  左上角检测中label
 */
@property (nonatomic, strong) UILabel *check_Label;

/**
 *  右边上面label
 */
@property (nonatomic, strong) UILabel *rightTop_Label;

/**
 *  右边下面label
 */
@property (nonatomic, strong) UILabel *rightBottom_Label;


@end
