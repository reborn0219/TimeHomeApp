//
//  BtmFilterTools.h
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  生活中房屋和车位租售底部条件工具栏
 *
 */
#import <UIKit/UIKit.h>

//菜单数据结构
@interface MenuModel : NSObject
/**
 *  标题
 */
@property(nonatomic,copy) NSString * title;
/**
 *  图片名称
 */
@property(nonatomic,copy) NSString * imgName;



@end


@interface BtmFilterTools : UIView

/**
 *  事件回调
 */
@property(nonatomic,copy) ViewsEventBlock eventCallBack;

/**
 *  条件数组
 */
@property(nonatomic,strong) NSMutableArray * FilterArray;

/**
 *  初始化方法
 *
 *  @param frame     frame 控件位置大小
 *  @param filterArr filterArr 条件数组
 *
 *  @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame filterArray:(NSMutableArray *) filterArr;
/**
 *  初始化方法带回调事件处理
 *
 *  @param frame     frame 控件位置大小
 *  @param filterArr filterArr 条件数组
 *  @param eventBlock eventBlock 事件回调
 *
 *  @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame filterArray:(NSMutableArray *) filterArr eventCall:(ViewsEventBlock )eventBlock;
/**
 *  设置事件回调
 *
 *  @param eventBlock eventBlock 回调
 */
-(void)setFilterEventCall:(ViewsEventBlock) eventBlock;
///改变时，设置标题
-(void)setTitleTextChangeForIndex:(NSInteger )index;

///设置颜色
-(void)setItemChangeForIndex:(NSInteger )index color:(UIColor *)color;


@end
