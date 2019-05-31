//
//  PAWaterDefinition.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#ifndef PAWaterDefinition_h
#define PAWaterDefinition_h

//-----------------App向饮水机发送的指令-------------------
//APP连接指令
extern NSString * const PAWaterConnectToDevice;

//APP接收到消费成功指令后回应指令（为保证消费成功
extern NSString * const PAWaterCoinSuccess;


//-----------------饮水机蓝牙返回状态----------------------
//连接成功 可进入下步消费买水
extern NSString * const PAWaterConnectionSuccess;

//连接成功 出水未完成无法进行下步消费
extern NSString * const PAWaterConnectionException;

//在接收成功后（模拟投币前）连接成功
extern NSString * const PAWaterBeforeCoin;

//在模拟投币成功后
extern NSString * const PAWaterAfterCoin;

//出水中
extern NSString * const PAWaterFlowing;

//非法金额
extern NSString * const PAWaterIllegalAmount;

//出水未完成
extern NSString * const PAWaterUnfinished;

//非法指令
extern NSString * const PAWaterIllegalInstructions;

//非法连接
extern NSString * const PAWaterIllegalConnect;

//帧头或帧尾错误
extern NSString * const PAWaterHeaderOrFooterError;

//其他错误
extern NSString * const PAWaterOtherError;

//重复投币
extern NSString * const PAWaterRepeatCoin;
#endif
