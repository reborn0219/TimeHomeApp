//
//  PhotoWallCell.h
//  TimeHomeApp
//
//  Created by us on 16/4/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoWallCell : UICollectionViewCell
///删除按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_Del;
///图片
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
///提示内容
@property (weak, nonatomic) IBOutlet UILabel *lab_Text;
@property(strong,nonatomic)NSIndexPath * indexPath;

@property(copy,nonatomic) CellEventBlock cellEventBlock;

@end
