//
//  RaiN_LabelTitleCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"

@interface RaiN_LabelTitleCell : THABaseTableViewCell
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImage *leftImage;
/**
 *  标题内容
 */
@property (nonatomic, strong) NSString *titleString;
@end
