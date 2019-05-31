//
//  THBaseTableViewCell.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  基类TableViewCell,大部分表均可自定义cell继承该cell
 *
 *  @param NSInteger              枚举值
 *  @param BaseTableViewCellStyle cell类型
 *
 *  @return 
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaseTableViewCellStyle) {
    /**
     *  leftLabel在左，rightLabel在右，arrowImage显示
     */
    BaseTableViewCellStyleDefault = 0,//
    /**
     *  leftLabel在左，rightLabel在leftLabel后面，arrowImage不显示
     */
    BaseTableViewCellStyleValue1 = 1,//
    /**
     *  只显示leftLabel,leftLabel在左
     */
    BaseTableViewCellStyleValue2 = 2,//
    /**
     *  左边图片，然后leftLabel，右边箭头
     */
    BaseTableViewCellStyleImageValue1 = 3,//
    /**
     *  leftLabel在左，右边箭头
     */
    BaseTableViewCellStyleValue3 = 4,
    /**
     *  leftLabel在左，右边箭头,前边带有星号*
     */
    BaseTableViewCellStyleValue4 = 5,
};

@interface THBaseTableViewCell : UITableViewCell

/**
 *  消息提示小红点
 */
@property (nonatomic, strong) UIImageView *infoImage;
/**
 *  右边的箭头图片
 */
@property (nonatomic, strong) UIImageView *arrowImage;
/**
 *  副标题
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  主标题
 */
@property (nonatomic, strong) UILabel *leftLabel;
/**
 *  左边小图片
 */
@property (nonatomic, strong) UIImageView *leftImageView;
/**
 *  单元格类型
 */
@property (nonatomic, assign) BaseTableViewCellStyle baseTableViewCellStyle;
/**
 *  传入头像，头像在右侧时
 *
 *  @param indexpath indexpath
 *  @param image     头像图片
 */
- (void)configureIndexpath:(NSIndexPath *)indexpath headImageUrl:(NSString *)imageString headImage:(UIImage *)headImage;

@end
