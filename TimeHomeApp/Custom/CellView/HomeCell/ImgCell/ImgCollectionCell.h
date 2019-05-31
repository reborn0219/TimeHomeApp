//
//  ImgCollectionCell.h
//  TimeHomeApp
//
//  Created by us on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgCollectionCell : UICollectionViewCell
///图片
@property (weak, nonatomic) IBOutlet UIImageView *img_Pic;
@property (weak, nonatomic) IBOutlet UIButton *btn_Del;
///上传失败提示信息
@property (weak, nonatomic) IBOutlet UILabel *lab_TiShi;
@property(nonatomic,copy)CellEventBlock eventBlock;
///索引
@property(nonatomic,strong)NSIndexPath * indexPath;


@end
