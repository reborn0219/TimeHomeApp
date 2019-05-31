//
//  PAWaterMoneyCardCell.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterMoneyCardCell.h"

@interface PAWaterMoneyCardCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PAWaterMoneyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.moneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
}

- (void)initUIWithLabelContent:(NSInteger)money{
    if (self.selected) {
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
        self.bgView.layer.borderWidth = 1.0;
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#007AFF"];
    }else{
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#B6C0D5"].CGColor;
        self.bgView.layer.borderWidth = 1.0;
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#464A54"];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld元",(long)money];
}


@end
