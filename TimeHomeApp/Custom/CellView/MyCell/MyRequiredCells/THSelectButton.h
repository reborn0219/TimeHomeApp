//
//  THSelectButton.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  维修评价的按钮封装
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TitleViewAligment) {
    /**
     *  标题图片label在左边
     */
    TitleViewAligmentLeft = 0,//
    /**
     *  在中间
     */
    TitleViewAligmentMiddle = 1,//
    /**
     *  在右边
     */
    TitleViewAligmentRight = 2,
};

@interface THSelectButton : UIButton
/**
 *  默认在左边
 */
@property (nonatomic, assign) TitleViewAligment titleViewAligment;
/**
 *  左边“点”那个图片
 */
@property (nonatomic, strong) UIImageView *dotImageView;
/**
 *  左边表情图片
 */
@property (nonatomic, strong) UIImageView *faceImageView;
/**
 *  按钮标题
 */
@property (nonatomic, strong) UILabel *rightLabel;
@end
