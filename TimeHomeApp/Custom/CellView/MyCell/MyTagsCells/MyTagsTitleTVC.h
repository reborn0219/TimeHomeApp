//
//  MyTagsTitleTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的标签界面中使用过，image+label
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import "THABaseTableViewCell.h"

@interface MyTagsTitleTVC : THABaseTableViewCell
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImage *leftImage;
/**
 *  标题内容
 */
@property (nonatomic, strong) NSString *titleString;

@end
