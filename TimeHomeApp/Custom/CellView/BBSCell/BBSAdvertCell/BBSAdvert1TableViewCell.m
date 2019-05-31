//
//  BBSAdvert1TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSAdvert1TableViewCell.h"

#import "ImageUitls.h"

@implementation BBSAdvert1TableViewCell

- (void)setModel:(BBSModel *)model {
    _model = model;
    
    self.titleLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.title]];
    CGSize size;
    self.infoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
    if ([model.redtype isEqualToString:@"0"]) {
        self.redPaperLayout.constant = 47;

        size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10 - 47 - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        if(size.height > 36.0){
            
            size.height = 36;
        }
        
        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
    }else if ([model.redtype isEqualToString:@"1"]){
        self.redPaperLayout.constant = 47;

        size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10 - 47 - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        if(size.height > 36.0){
            
            size.height = 36;
        }
        
        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-粉包图标"];
    }else if ([model.redtype isEqualToString:@"-1"]){
        
        self.redPaperLayout.constant = 0;
        self.redPaper.image = [UIImage imageNamed:@""];
        size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10 - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        if(size.height > 36.0){
            
            size.height = 36;
        }
    }
    self.tag2Lal.layer.cornerRadius = 8;
    self.tag2Lal.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [self.tag2Lal.layer setBorderWidth:1];
    [self.tag2Lal.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    
    NSArray *imgArr = model.piclist;
    
    NSDictionary *dict1 = imgArr[0];
    NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image1 withName:url1];
    
    if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.commentcount]] isEqualToString:@""]) {
        
        self.commentLal.text = @"0";
    }else{
        self.commentLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.commentcount]];
    }
    
    if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]] isEqualToString:@""]) {
        
        self.praiseLal.text = @"0";
    }else{
        self.praiseLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]];
    }
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
    
    float height = 13 + 5 + 21 + 5 + size.height + 5 + 8 + 1 + 15 + 20 + 15 + 10 + (SCREEN_WIDTH - 20 - 2 * 8) / 648 * 432;
    
    model.height = height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
