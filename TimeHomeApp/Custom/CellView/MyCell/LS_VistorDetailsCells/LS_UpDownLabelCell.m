//
//  LS_UpDownLabelCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "LS_UpDownLabelCell.h"
#import "LS_VistorDetailsVC.h"

@implementation LS_UpDownLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)assignment:(id)object
{
    UpDownModel * UDML = object;
    
    self.upLb.text   = UDML.title;
    self.downLb.text = UDML.coutent;
}

@end
