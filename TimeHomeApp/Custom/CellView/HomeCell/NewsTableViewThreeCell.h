//
//  NewsTableViewThreeCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  新闻列表Cell三张图
 */
#import <UIKit/UIKit.h>

@interface NewsTableViewThreeCell : UITableViewCell
/**
 *  新闻标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  新闻图片1
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic1;
/**
 *  新闻图片3
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic2;
/**
 *  新闻图片3
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic3;
/**
 *  新闻类型
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_NewsType;
/**
 *  新闻发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

@end
