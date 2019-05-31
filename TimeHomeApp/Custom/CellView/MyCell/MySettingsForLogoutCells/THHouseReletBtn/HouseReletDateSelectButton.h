//
//  HouseReletDateSelectButton.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在房屋续租中使用过
 *
 *  @param NSInteger
 *  @param TextStyle 选择时间的枚举
 *
 *  @return
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextStyle) {
    /**
     *  开始时间
     */
    TextStyleBeginDate = 0,
    /**
     *  结束时间
     */
    TextStyleEndDate = 1,
};
@interface HouseReletDateSelectButton : UIButton
/**
 *  右边按钮标题
 */
@property (nonatomic, strong) UILabel *dateLabel;
/**
 *  时间类型选择枚举
 */
@property (nonatomic, assign) NSInteger dateStyle;

@end
