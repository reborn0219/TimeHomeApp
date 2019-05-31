//
//  GarageDetailCarCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车位详情车牌列表样式
#import <UIKit/UIKit.h>

@interface GarageDetailCarCell : UITableViewCell

///初始化图标
@property (weak, nonatomic) IBOutlet UIImageView *img_Icon;

///车牌
@property (weak, nonatomic) IBOutlet UILabel *lab_CarNum;
///姓名
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
///删除
@property (weak, nonatomic) IBOutlet UIButton *btn_Del;
///右边竖线
@property (weak, nonatomic) IBOutlet UIView *view_VLine;
///索引
@property(nonatomic,strong)NSIndexPath * index;
///删除事件回调
@property(nonatomic,copy)CellEventBlock cellEventBlock;

@end
