//
//  THAuthoritySelectButton.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  封装的按钮，样子为image+label+image
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>

@interface THAuthoritySelectButton : UIButton
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImageView *leftImageView;
/**
 *  左边label
 */
@property (nonatomic, strong) UILabel *leftLabel;
/**
 *  右边图片
 */
@property (nonatomic, strong) UIImageView *rightImageView;

@end
