//
//  THHomeGridViewListItemView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  每个图片的所在的view
 */
#import <UIKit/UIKit.h>
#import "UserPhotoWall.h"


@interface THHomeGridViewListItemView : UIView
/**
 *  每个按钮
 */
@property (nonatomic, strong) UIButton *itemButton;
/**
 *  每个model
 */
@property (nonatomic, strong) UserPhotoWall *photoWall;
/**
 *  头像显示label,默认隐藏
 */
@property (nonatomic, strong) UILabel *headLabel;
/**
 *  每个图片
 */
//@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) NSString *imageUrl;
/**
 *  每个item的长按手势
 */
@property (nonatomic, copy) void (^itemLongPressedOperationBlock)(UILongPressGestureRecognizer *longPressed);
/**
 *  button的点击事件
 */
@property (nonatomic, copy) void (^buttonClickedOperationBlock)(THHomeGridViewListItemView *item);
/**
 *  删除按钮点击事件
 */
@property (nonatomic, copy) void (^cancelButtonClickedOperationBlock)(THHomeGridViewListItemView *view);

@end
