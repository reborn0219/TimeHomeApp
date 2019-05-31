//
//  MineTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的首页使用的基本cell,与后面封装的THBaseTableViewCell中的一种类型相同
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>

@interface MineTVC : UITableViewCell
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImageView *leftImageView;
/**
 *  左边标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  右边图片
 */
@property (nonatomic, strong) UIImageView *accessoryImage;
/**
 *  消息提示红点图片
 */
@property (nonatomic, strong) UIImageView *infoImage;

@end
