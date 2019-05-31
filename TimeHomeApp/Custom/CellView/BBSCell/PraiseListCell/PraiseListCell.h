//
//  PraiseListCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *zanLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img_H;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
