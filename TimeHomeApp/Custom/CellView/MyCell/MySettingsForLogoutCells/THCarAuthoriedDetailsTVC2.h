//
//  THCarAuthoriedDetailsTVC2.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerResidenceUser.h"
/**
 *  车位权限 续租
 */
@interface THCarAuthoriedDetailsTVC2 : UITableViewCell
/**
 *  租期label
 */
@property (nonatomic, strong) UILabel *topLabel;
/**
 *  时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  右边自定义图片
 */
@property (nonatomic, strong) UIImageView *rightImage;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) OwnerResidenceUser *ownerResidenceUser;

@end
