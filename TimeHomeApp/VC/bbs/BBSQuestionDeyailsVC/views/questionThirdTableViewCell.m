//
//  questionThirdTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "questionThirdTableViewCell.h"

@implementation questionThirdTableViewCell

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
    NSString *contentString1 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.answercount]];
    
    self.answerLal.text = contentString1;
    
    NSString *contentString2 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.pvcount]];
    
    self.BrowseLal.text = contentString2;

    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
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
