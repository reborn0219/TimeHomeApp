//
//  BaseViewController.h
//  FBaseApp
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 FCJ. All rights reserved.
//
/**
 所有视图控制器基类，实现公共方法。
 **/
#import <UIKit/UIKit.h>
#import "BasePresenters.h"
#import "MacroDefinition.h"
#import "AnimtionUtils.h"
#import "THIndicatorVC.h"
#import "NothingnessView.h"

@interface BaseViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic,assign)BOOL isToakenNone;//是否失效
@property (nonatomic,copy)NSMutableArray * typesArr;
@property (nonatomic,copy)NSString * saveKey;
@property (nonatomic,copy)NSString * ls_typeStr;

@property(nonatomic,strong) NothingnessView * nothingnessView;
///是否正在显示引导图
//@property(nonatomic,assign)BOOL isShowMaskingViewArrays;

//消息提示并自动消失
- (void)showAlertMessage:(NSString *)message Duration:(float)duration;
//消息提示Toast
-(void)showToastMsg:(NSString *)message Duration:(float)duration;
//子类处理消息接收
-(void)subReceivePushMessages:(NSNotification*) aNotification;


/**
 *  显示无数据或加载失改视图
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg     msg  显示无数据提示
 */
-(void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg eventCallBack:(ViewsEventBlock) callBack;
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
 *  隐藏数据或加载失改视图
 */
-(void)hiddenNothingnessView;
/**
 *  显示新手引导图  例如：CGRect rect = CGRectMake(0,100,SCREEN_WIDTH,100);
 [self showMaskingViewArrays:@[@"邻圈",@"首页"] frameArray:@[@"",NSStringFromCGRect(rect)]];
 *  @param imageNameArray 引导图片名字数组
 *  @param frameArray     引导图片位置字符串数组（一张图片时可传空,传数组时若无特定位置可传 @"" 默认为全屏位置）,当为最后一张图时点击自动隐藏
 */
//- (void)showMaskingViewArrays:(NSArray *)imageNameArray frameArray:(NSArray *)frameArray;


/**
 相机权限判断
 */
- (BOOL)canOpenCamera;

/**
 定位权限判断
 */
- (BOOL)isUseLocation;

/**
 麦克风权限判断
 */
- (BOOL)isUseMicrophone;

/**
 判断当前栈中是否有某个控制器
 @param subscript 堆栈数组下标
 @param viewController 控制器
 */
- (BOOL)isHaveTheStack:(int)subscript andViewController:(Class)viewController;

/**
 商城入口
 */
-(void)comeingoodsWithCallBack:(void(^)())callBack;

/**
 跳转app的系统设置中
 */
//- (void)gotoAppSystemSettings;

/**
 消息类型处理

 @param type 新来消息类型
 @param isAdd 添加还是删除
 */
-(void)setUpTheTypes:(NSString *)type AddOrDelete:(BOOL)isAdd;


/**
 判断是否有emoji
 */
-(BOOL)stringContainsEmoji:(NSString *)string;


/**
 通过storyboardName 和 identifier 加载出baseController的子类

 @param name storyboardName
 @param identifier identifier description
 @return viewController
 */
- (id)viewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)identifier;
@end
