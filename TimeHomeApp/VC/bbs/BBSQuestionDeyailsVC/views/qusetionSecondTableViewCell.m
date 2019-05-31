//
//  qusetionSecondTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "qusetionSecondTableViewCell.h"

@implementation qusetionSecondTableViewCell

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
    NSString *contentString1 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.title]];
    
    self.titleLal.text = contentString1;
    
    NSString *contentString2 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
    
    self.infoLal.text = contentString2;
    
    if([model.rewardtype isEqualToString:@"0"]){
        
        self.backLeft.image = [UIImage imageNamed:@"邻趣-首页-问答贴-现金框"];
        self.backRight.image = [UIImage imageNamed:@"邻趣-首页-问答贴现金图标"];
        self.moneyLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"￥%@",model.rewardmoney]];
    }else if ([model.rewardtype isEqualToString:@"1"]){
        
        self.backLeft.image = [UIImage imageNamed:@"邻趣-首页-问答贴-积分框"];
        self.backRight.image = [UIImage imageNamed:@"邻趣-首页-问答贴积分图标"];
        self.moneyLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.rewardmoney]];
    }else{
        
        self.backLeft.image = [UIImage imageNamed:@""];
        self.backRight.image = [UIImage imageNamed:@""];
        self.moneyLal.text = @"";
    }
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
    
    float height;
    
    if (contentString2.length == 0) {
        
        CGFloat rectY1 = CGRectGetMaxY(self.titleLal.frame);
        height = rectY1;
    }else{
        
        CGFloat rectY2 = CGRectGetMaxY(self.infoLal.frame);
        height = rectY2;
    }

    model.contentHeight = height + 10;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLal.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16;
    _infoLal.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16 - 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
