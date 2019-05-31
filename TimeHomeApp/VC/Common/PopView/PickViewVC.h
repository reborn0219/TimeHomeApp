//
//  PickViewVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 * pickView选择
 */
#import "BaseViewController.h"

@interface PickViewVC : BaseViewController
/**
 *  显示条件列表
 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;

/**
 *  选中值，包括默认值
 */
@property(nonatomic,copy) NSString * selectStr;
/**
 *  选中后事件回调
 */
@property(nonatomic,copy)ViewsEventBlock selectCallBack;

/**
 *  返回实例
 *
 *  @return return value description
 */
+(PickViewVC *)getInstance;

/**
 *  显示
 *
 *  @param parent parent description
 *  @param data   要显示的数据
 */
-(void)showPickView:(UIViewController *) parent pickData:(NSArray *)data;
/**
 *  显示
 *
 *  @param parent        parent description
 *  @param data          data description
 *  @param eventCallBack 事件回调
 */
-(void)showPickView:(UIViewController *) parent pickData:(NSArray *)data EventCallBack:(ViewsEventBlock)eventCallBack;
@end
