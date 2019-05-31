//
//  CarPopupView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/8/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MMPopupView.h"

/**
 *  车况检测故障描述弹出框
 */
@interface CarPopupView : MMPopupView

//+(instancetype)sharedCarPopupView;

/**
 *  故障码
 */
@property (nonatomic, strong) NSString *faultNum;
/**
 *  故障描述
 */
@property (nonatomic, strong) NSString *faultDescribe;
/**
 *  详情
 */
@property (nonatomic, strong) NSString *details;

/**
 *  故障码隐藏
 */
@property (nonatomic, assign) BOOL hiddenFaultCode;

@end
