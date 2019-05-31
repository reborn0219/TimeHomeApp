//
//  PraiseListCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PraiseListCell.h"

@implementation PraiseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headerImgV.layer.masksToBounds = YES;
    _headerImgV.layer.cornerRadius  = (70-30)/2.0f;
//    UIGraphicsBeginImageContextWithOptions(_headerImgV.bounds.size, NO, [UIScreen mainScreen].scale); //使用贝塞尔曲线画出一个圆形图
//    [[UIBezierPath bezierPathWithRoundedRect:_headerImgV.bounds cornerRadius:_headerImgV.frame.size.width] addClip];
//    [_headerImgV drawRect:_headerImgV.bounds];
//    _headerImgV.image = UIGraphicsGetImageFromCurrentImageContext(); //结束画图
//    UIGraphicsEndImageContext();
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
