//
//  GarageAddCarHeardView.h
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加车牌事件类型
typedef NS_ENUM(NSInteger,AddCarEventCodeType)
{
    ///确认
    ADDCAR_OK=100,
    ///取消
    ADDCAR_CANCEL,
};

@interface GarageAddCarHeardView : UIView
/**
 *  车牌第一位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumFirstChar;
/**
 *  车牌第二位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumSecondChar;
/**
 *  后五位
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_CarNumText;
/**
 *  车主姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_CarOwnerName;
@property(weak,nonatomic) BaseViewController * viewController;


/**
 *  事件处理回调
 */
@property(copy,nonatomic) ViewsEventBlock eventCallBack;


/**
 *  获取实例
 *
 *  @return
 */
+(GarageAddCarHeardView *)getInstanceView;
@end
