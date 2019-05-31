//
//  THCarAuthoriedDetailsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerResidenceUser.h"
/**
 *  车位权限 移除
 */
@interface THCarAuthoriedDetailsTVC : UITableViewCell

/**
 *  右边自定义图片
 */
@property (nonatomic, strong) UIImageView *rightImage;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  左边手机号label
 */
@property (nonatomic, strong) UILabel *mobileLabel;
/**
 *  左边名字label
 */
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) OwnerResidenceUser *ownerResidenceUser;

@end
