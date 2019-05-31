//
//  THHouseAuthorityDetailsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在房产权限和车位权限中使用过（暂时废弃）
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return 
 */
#import "THABaseTableViewCell.h"
//#import "TTTAttributedLabel.h"

@interface THHouseAuthorityDetailsTVC : UITableViewCell
/**
 *  右边自定义图片
 */
@property (nonatomic, strong) UIImageView *rightImage;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  左边label
 */
@property (nonatomic, strong) UILabel *leftLabel;
//@property (nonatomic, strong) TTTAttributedLabel *leftLabel;

@end
