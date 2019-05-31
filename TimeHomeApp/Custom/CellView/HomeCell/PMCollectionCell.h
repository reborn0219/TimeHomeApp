//
//  PMCollectionCell.h
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  物业服务Cell视图
 */
#import <UIKit/UIKit.h>

@interface PMCollectionCell : UICollectionViewCell
/**
 *  图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Icon;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  英文图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_English;
/**
 *  背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *view_BackBg;




@end
