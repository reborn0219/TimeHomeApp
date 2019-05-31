//
//  THMySubRegionListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"

#import "UserCommunity.h"
#import "UserCertlistModel.h"

@interface THMySubRegionListTVC : THABaseTableViewCell

/**
 *  标题label
 */
@property (nonatomic, strong) UILabel *topTitleLabel;
/**
 *  下方内容label
 */
@property (nonatomic, strong) UILabel *bottomLabel;
/**
 *  右边为label时的label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  右边为image时的imageview
 */
@property (nonatomic, strong) UIImageView *rightImageView;
/**
 *  传递的当前社区model
 */
@property (nonatomic, strong) UserCommunity *user;
/**
 *  传递的已认证社区集合model
 */
@property (nonatomic, strong) UserCertlistModel *certlistModel;
@end
