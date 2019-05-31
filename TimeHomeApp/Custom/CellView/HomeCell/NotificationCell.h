//
//  NotificationCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  通知公告Cell
 */
#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
/**
 *  通知图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Icon;
/**
 *  通知标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  发布内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;
/**
 *  发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

@end
