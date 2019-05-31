//
//  THHouseAuthoriedTVC1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerResidence.h"
/**
 *  房产权限 未授权 已共享
 */
@interface THHouseAuthoriedTVC1 : UITableViewCell

/**
 *  右边箭头图片
 */
@property (nonatomic, strong) UIImageView *arrowImage;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  左边label
 */
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) OwnerResidence *ownerResidence;
/**
 *  0未授权 1已共享
 */
@property (nonatomic, assign) NSInteger type;

@end
