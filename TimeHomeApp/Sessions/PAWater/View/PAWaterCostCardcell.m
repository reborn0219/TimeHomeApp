//
//  PAWaterCostCardcell.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterCostCardcell.h"
@interface PAWaterCostCardcell()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterNumLabel;
@end
@implementation PAWaterCostCardcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWaterNumLabelContent:(CGFloat )waterNum{
    self.waterNumLabel.text = [NSString stringWithFormat:@"%0.1f L",waterNum];
    [self.countLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
}

@end
