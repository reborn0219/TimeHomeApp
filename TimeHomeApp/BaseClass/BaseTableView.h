//
//  BaseTableView.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NothingnessView.h"

// 无数据占位图的类型
//typedef NS_ENUM(NSInteger, NoContentImageType) {
//    /** 无数据 */
//    NoContentImageTypeData   = 0,
//    /** 无网络 */
//    NoContentImageTypeNetwork = 1,
//    /** 暂未发表 */
//    NoContentImageTypePublish = 2
//};

@interface BaseTableView : UITableView

@property(nonatomic,strong) NothingnessView * nothingnessView;

/**
 *  显示无数据或加载失改视图
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg           msg  显示无数据提示
 */
- (void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg eventCallBack:(ViewsEventBlock) callBack;

/**
 *  显示无数据或加载失改视图有按钮和事件处理
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg      msg 显示无数据提示
 *  @param subMsg   subMsg 显示无数据子提示
 *  @param title    title 按钮文字
 *  @param callBack callBack 事件回调
 */
-(void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg SubMsg:(NSString *) subMsg btnTitle:(NSString *)title eventCallBack:(ViewsEventBlock) callBack;

/**
 隐藏无数据或加载失改视图
 */
- (void)hiddenNothingView;

@end
