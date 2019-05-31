//
//  GarageAddCarCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///添加车牌列表样式
#import <UIKit/UIKit.h>

@interface GarageAddCarCell : UITableViewCell
///车牌号
@property (weak, nonatomic) IBOutlet UILabel *lab_CarNum;
///姓名
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
///选择
@property (weak, nonatomic) IBOutlet UIButton *btn_Select;

@property(nonatomic,strong)NSIndexPath * indexpath;
///事件回调
@property(nonatomic,copy)CellEventBlock cellEventBlock;

@end
