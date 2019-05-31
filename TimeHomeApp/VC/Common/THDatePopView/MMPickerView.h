//
//  MMPickerView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MMPopupView.h"
typedef void(^confirmClick)(NSString *data);
@interface MMPickerView : MMPopupView

@property (nonatomic, strong) confirmClick confirm;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *titleString;

/**
 *  选中值，包括默认值
 */
@property(nonatomic,copy) NSString * selectStr;
/**
 *  传入的数组
 */
@property(nonatomic,copy) NSArray * dataArray;

@end
