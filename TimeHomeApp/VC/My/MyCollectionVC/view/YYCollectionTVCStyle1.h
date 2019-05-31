//
//  YYCollectionTVCStyle1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我收藏的房源model
 */
#import "UserPublishRoom.h"
#import "UserReservePic.h"

@interface YYCollectionTVCStyle1 : UITableViewCell


/**
 *  左边的图片
 */
@property (nonatomic, strong) UIImageView *left_ImageView;
/**
 *  右边名称标题
 */
@property (nonatomic, strong) UILabel *title_Label;
/**
 *  右边名称副标题
 */
@property (nonatomic, strong) UILabel *detail_Label;
/**
 *  右边价格
 */
@property (nonatomic, strong) UILabel *price_Label;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *time_Label;

/**
 *  我收藏的房源model
 */
@property (nonatomic, strong) UserPublishRoom *userRoom;


@end
