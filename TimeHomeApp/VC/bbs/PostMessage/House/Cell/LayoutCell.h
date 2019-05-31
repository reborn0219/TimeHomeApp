//
//  LayoutCell.h
//  Bessel
//
//  Created by 赵思雨 on 2016/12/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeImageAddBackgroundView.h"
@interface LayoutCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end
