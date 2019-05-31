//
//  THRentAlertView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MMPopupView.h"


typedef void (^ ConfirmButtonClickCallBack)(NSInteger buttonIndex,NSString *beginDateString,NSString *endDateString);

typedef void (^ DateButtonClickCallBack)(NSString *beginDateString,NSInteger buttonIndex);

@interface THRentAlertView : MMPopupView
/**
 *  开始日期
 */
@property (nonatomic, strong) NSString *beginDateString;
/**
 *  结束日期
 */
@property (nonatomic, strong) NSString *endDateString;
/**
 *  选择日期回调
 */
@property (nonatomic, copy) DateButtonClickCallBack dateButtonClickCallBack;
/**
 *  确定按钮回调
 */
@property (nonatomic, copy) ConfirmButtonClickCallBack confirmButtonClickCallBack;
/**
 *  单例
 *
 *  @return 
 */
+(instancetype)shareRentAlert;

@end
