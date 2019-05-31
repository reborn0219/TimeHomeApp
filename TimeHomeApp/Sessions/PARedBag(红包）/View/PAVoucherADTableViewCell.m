//
//  PAVoucherADTableViewCell.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/12.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherADTableViewCell.h"

@interface PAVoucherADTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@end

@implementation PAVoucherADTableViewCell

-(void)setBackgroundpic:(NSString *)backgroundpic{
    if (backgroundpic) {
        _backgroundpic = backgroundpic;
    }
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:_backgroundpic]
                          placeholderImage:[UIImage imageNamed:@""]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
