//
//  CarLocationCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  车辆定位显示Cell
 */
#import <UIKit/UIKit.h>

@interface CarLocationCell : UITableViewCell

/**
 *  车牌号
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_CarNum;
/**
 *  当前地址
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Addr;

///列表中的索引
@property(nonatomic,strong) NSIndexPath * indexpath;
/**
 *  编辑事件回调
 */
@property(nonatomic,copy) CellEventBlock editCallBack;
/**
 *  删除事件回调
 */
@property(nonatomic,copy) CellEventBlock delCallBack;


@end
