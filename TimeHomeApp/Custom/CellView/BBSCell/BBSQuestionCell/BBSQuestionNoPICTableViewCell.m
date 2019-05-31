//
//  BBSQuestionNoPICTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSQuestionNoPICTableViewCell.h"

#import "ImageUitls.h"

@implementation BBSQuestionNoPICTableViewCell

- (void)setModel:(BBSModel *)model {
    _model = model;
    
    CGSize size;
    
    NSString *contentString = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.title]];
//    if (contentString.length > wordCount) {
//        contentString = [NSString stringWithFormat:@"%@...",[contentString substringToIndex:wordCount]];
//    }
    
    size = [contentString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    float hideShow = 0;
    if(size.height >= 90.0){
        
        size.height = 90;
        self.allTextLayout.constant = 15;
        hideShow = 15;
        self.allTextLal.textColor = NEW_BLUE_COLOR;
    }else{
        
        self.allTextLayout.constant = 0;
        self.allTextLal.textColor = [UIColor clearColor];
    }
    
    if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",contentString]] isEqualToString:@""]) {
        
        size.height = 0.0;
    }
    self.infoLal.text = contentString;
    
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

    self.headView.contentMode = UIViewContentModeScaleToFill;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:kHeaderPlaceHolder];
    self.headView.layer.cornerRadius = 10;
    self.headView.layer.masksToBounds = YES;
    self.nameLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.nickname]];
    self.nameLal.textColor = UIColorFromRGB(0x595353);
    
    if(self.type == 2){
        
        /** 发布时间 */
        
        self.cityList.userInteractionEnabled = YES;
        
        self.timeHideLal.hidden = NO;
        self.timeHideLal.text = [XYString IsNotNull:model.releasetime];
        
        self.cityImgWidth.constant = 20;
        self.commImg.image = [UIImage imageNamed:@"邻趣-首页-帖子-定位图标"];
        
        self.l_timeLabel.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.communityname]];
        self.l_timeLabel.textColor = NEW_BLUE_COLOR;
    }else{
        
        self.cityList.userInteractionEnabled = NO;
        
        self.timeHideLal.hidden = YES;
        self.timeHideLal.text = @"";
        
        self.cityImgWidth.constant = 0;
        self.commImg.image = [UIImage imageNamed:@""];
        
        self.l_timeLabel.text = [XYString IsNotNull:model.releasetime];
        self.l_timeLabel.textColor = UIColorFromRGB(0x8e8e8e);
    }
    
    if (self.top == 1) {
        
        self.topTag.hidden = NO;
        self.topLayout.constant = 20;
        self.topTag.layer.cornerRadius = 8;
        self.topTag.layer.masksToBounds = YES;
        //边框宽度及颜色设置
        [self.topTag.layer setBorderWidth:1];
        [self.topTag.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    }else{
        
        self.topTag.hidden = YES;
        self.topLayout.constant = 0;
    }

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
    
    float height = 18 + 13 + 12 + size.height + 7 + hideShow + 6 + 1 + 10 + 20 + 10 + 10 + 20 + 5;
    
    model.height = height;
}

- (IBAction)cityTouch:(id)sender {
    
    if (self.cityButtonDidClickBlock) {
        
        self.cityButtonDidClickBlock(0);
    }
}

- (IBAction)commListTouch:(id)sender {
    
    if (self.commButtonDidClickBlock) {
        
        self.commButtonDidClickBlock(0);
    }
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
