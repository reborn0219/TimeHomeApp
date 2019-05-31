//
//  PricePopVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  价格选择
 *
 */
#import "BaseViewController.h"

@interface PricePopVC : BaseViewController
/**
 *  标尺段标题数据
 */
@property(nonatomic,strong)NSArray * arryLabTitle;
/**
 *  事件回调
 */
@property(nonatomic,copy) ViewsEventBlock eventCallBack;
/**
 *  默认开始位置
 */
@property(nonatomic,assign) NSInteger start;
/**
 *  默认结束位置
 */
@property(nonatomic,assign) NSInteger end;

/**
 *  获取实例
 *
 *  @return return value PricePopVC
 */
+(PricePopVC *)getInstance;


/**
 *  显示
 *
 *  @param parent       上级控制器
 *  @param data     标尺段标题数据
 *  @param callBack 事件回调
 */
-(void)showPickPopView:(UIViewController *) parent data:(NSArray *) data eventCallBack:(ViewsEventBlock) callBack;

@end
