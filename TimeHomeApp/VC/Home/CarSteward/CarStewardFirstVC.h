//
//  CarStewardFirstVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 * 汽车管家
 **/
 
#import "BaseViewController.h"

//添加车牌事件类型
typedef NS_ENUM(NSInteger,AddCarEventCodeType)
{
    ///确认
    ADDCAR_OK=100,
    ///取消
    ADDCAR_CANCEL,
    ///第一个下拉选择
    ADDCAR_FIRST,
    ///第二个下拉选择
    ADDCAR_SECOND
};

@interface CarStewardFirstVC : THBaseViewController

@property (nonatomic, copy)NSString *carNumberStr; //传入的车牌ID
@property (nonatomic, copy)NSString *carNameStr; //第一次进入车牌str

@property (nonatomic, copy)NSString *picUrl; //品牌图标地址
@property (nonatomic, strong)NSMutableArray *cell2LeftShowArr; //cell2左边的展示数据
@property (nonatomic, strong)NSMutableArray *cell2RightShowArr; //cell2右边的展示数据
@property (nonatomic, strong)NSMutableArray *cell4ShowArr; //cell4的展示数据

@property (nonatomic, copy)NSString *uCarID;
/**
 *  事件处理回调
 */
@property(copy,nonatomic) ViewsEventBlock eventCallBack;
@end
