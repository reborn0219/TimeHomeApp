//
//  BBSNormal1TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSNormal1TableViewCell.h"

#import "ImageUitls.h"

@implementation BBSNormal1TableViewCell

- (void)setModel:(BBSModel *)model {
    _model = model;
    

    NSString *contentString = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
//    if (contentString.length > wordCount) {
//        contentString = [NSString stringWithFormat:@"%@...",[contentString substringToIndex:wordCount]];
//    }
    self.infoLal.text = contentString;
    
    if ([model.redtype isEqualToString:@"0"]) {
        self.redPaperLayout.constant = 47;
        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
    }else if ([model.redtype isEqualToString:@"1"]){
        self.redPaperLayout.constant = 47;

        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-粉包图标"];
    }else if ([model.redtype isEqualToString:@"-1"]){
        
        self.redPaper.image = [UIImage imageNamed:@""];
        self.redPaperLayout.constant = 0;
    }
    
    NSArray *imgArr = model.piclist;
    
    NSDictionary *dict1 = imgArr[0];
    NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image1 withName:url1];
    
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
        
        self.topLayout.constant = 20;
        self.topTag.hidden = NO;
        self.topTag.layer.cornerRadius = 8;
        self.topTag.layer.masksToBounds = YES;
        //边框宽度及颜色设置
        [self.topTag.layer setBorderWidth:1];
        [self.topTag.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    }else{
        
        self.topLayout.constant = 0;
        self.topTag.hidden = YES;
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
    
    /** 是否点赞 */
    if (model.ispraise.integerValue == 0) {
        
        _l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
        
    }else {
        
        _l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
        
    }
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    [self layoutIfNeeded];
    
    float height = 13 + 47 + 5 + 8 + 1 + 10 + 20 + 10 + 10 + 20 + 5 +(SCREEN_WIDTH - 20 - 2 * 8) / 648 * 432;
    
    //CGFloat height = CGRectGetMaxY(_bottomView.frame);
    
    model.height = height;
    
}

/**
 点赞
 */
- (IBAction)l_praiseButtonDidTouch:(UIButton *)sender {
    
    NSLog(@"点赞");
    if (_model.ispraise.integerValue == 0) {
        
//        _model.isPraise = @"1";
//        
//        _model.praisecount = [NSString stringWithFormat:@"%ld",_model.praisecount.integerValue + 1];
//        
//        if (_model.praisecount.integerValue > 0) {
//            self.praiseLal.text = [NSString stringWithFormat:@"%ld",_model.praisecount.integerValue];
//        }else {
//            _model.praisecount = @"0";
//            self.praiseLal.text = @"0";
//        }
//        
//        _l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
        
        if (self.praiseButtonDidClickBlock) {
            self.praiseButtonDidClickBlock(0);
        }
        
    }else {
        
//        _model.isPraise = @"0";
//        
//        _model.praisecount = [NSString stringWithFormat:@"%ld",_model.praisecount.integerValue - 1];
//        
//        if (_model.praisecount < 0) {
//            _model.praisecount = @"0";
//            self.praiseLal.text = @"0";
//        }else {
//            self.praiseLal.text = [NSString stringWithFormat:@"%ld",_model.praisecount.integerValue];
//        }
//        
//        _l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
        
        if (self.praiseButtonDidClickBlock) {
            self.praiseButtonDidClickBlock(1);
        }
        
    }
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _infoLal.preferredMaxLayoutWidth = SCREEN_WIDTH - 88;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
