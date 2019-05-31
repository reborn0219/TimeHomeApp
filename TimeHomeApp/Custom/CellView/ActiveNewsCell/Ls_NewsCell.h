//
//  Ls_NewsCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/1/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ls_NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImgV;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *newsubTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *newsContentLb;

@end
