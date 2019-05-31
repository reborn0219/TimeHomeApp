//
//  HouseTableCellTableViewCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  房屋出租/售列表显示
 *
 */
#import <UIKit/UIKit.h>

@interface HouseTableCell : UITableViewCell
///图片
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
///标题
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
///室，区域
@property (weak, nonatomic) IBOutlet UILabel *lab_QuYu;
///价格
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
///发布时间
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

@end
