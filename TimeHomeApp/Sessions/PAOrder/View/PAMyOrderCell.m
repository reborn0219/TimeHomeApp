//
//  PAMyOrderCell.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMyOrderCell.h"

@interface PAMyOrderCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PAMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.iconImageView.image = [UIImage imageNamed:dataDict[@"image"]];
    self.titleLabel.text = dataDict[@"title"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
