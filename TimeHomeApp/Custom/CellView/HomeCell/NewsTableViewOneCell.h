//
//  NewsTableViewCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  新闻列表Cell一张大图
 */
#import <UIKit/UIKit.h>

@interface NewsTableViewOneCell : UITableViewCell
/**
 *  热门图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_hotIcon;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  新闻图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
/**
 *  新闻类型
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Type;

/**
 *  发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

@end
