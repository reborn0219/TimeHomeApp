//
//  ActivitysTableViewCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  活动列表cell
 */
#import <UIKit/UIKit.h>

@interface ActivitysTableViewCell : UITableViewCell
/**
 *  活动图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
/**
 *  活动标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  活动状态或类型
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_State;
/**
 *  活动时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;
/**
 *  活动内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;

@end
