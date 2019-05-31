//
//  RedPacketsCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *bestLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLb_content;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *nickeLb;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *huangguanImgV;
-(void)isTheBest:(BOOL)isBest;
@end
