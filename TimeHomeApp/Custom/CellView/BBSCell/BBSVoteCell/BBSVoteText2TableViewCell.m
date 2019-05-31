//
//  BBSVoteText2TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSVoteText2TableViewCell.h"

#import "ImageUitls.h"

@implementation BBSVoteText2TableViewCell

- (void)setModel:(BBSModel *)model {
    _model = model;
    
    self.infoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
    if ([model.redtype isEqualToString:@"0"]) {
        self.redPaperLayout.constant = 47;

        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
    }else if ([model.redtype isEqualToString:@"1"]){
        self.redPaperLayout.constant = 47;

        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-粉包图标"];
    }else if ([model.redtype isEqualToString:@"-1"]){
        
        self.redPaperLayout.constant = 0;
        self.redPaper.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
    }
    
    if(self.type == 2){
        
        self.headView.image = [UIImage imageNamed:@"邻趣-首页-帖子-定位图标"];
        self.headView.contentMode = UIViewContentModeCenter;
        
        self.nameLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.communityname]];
        self.nameLal.textColor = NEW_BLUE_COLOR;
    }else{
        
        self.headView.contentMode = UIViewContentModeScaleToFill;
        [self.headView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:kHeaderPlaceHolder];
        self.headView.layer.cornerRadius = 10;
        self.headView.layer.masksToBounds = YES;
        self.nameLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.nickname]];
        self.nameLal.textColor = UIColorFromRGB(0x595353);
    }
    
    if (self.top == 1) {
        
        self.topLayout.constant = 20;
        self.topTag.layer.cornerRadius = 8;
        self.topTag.layer.masksToBounds = YES;
        //边框宽度及颜色设置
        [self.topTag.layer setBorderWidth:1];
        [self.topTag.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    }else{
        
        self.topLayout.constant = 0;
    }
    
    NSArray *arr = model.itemlist;
    
    int red1 = [arr[0][@"votocount"] intValue];
    int red2 = [arr[1][@"votocount"] intValue];
    
    self.voteInfo1Lal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",arr[0][@"content"]]];
    self.voteNumber1Lal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%d",red1]];

    self.back1View.layer.cornerRadius = 8;
    self.back1View.layer.masksToBounds = YES;
    self.red1View.layer.cornerRadius = 8;
    self.red1View.layer.masksToBounds = YES;
    self.whitePoint1.layer.cornerRadius = 2;
    self.whitePoint1.layer.masksToBounds = YES;
    
    self.voteInfo2Lal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",arr[1][@"content"]]];
    self.voteNumber2Lal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%d",red2]];
    self.back2View.layer.cornerRadius = 8;
    self.back2View.layer.masksToBounds = YES;
    self.red2View.layer.cornerRadius = 8;
    self.red2View.layer.masksToBounds = YES;
    self.whitePoint2.layer.cornerRadius = 2;
    self.whitePoint2.layer.masksToBounds = YES;
    
    self.number.text = [NSString stringWithFormat:@"共%@项投票",model.itemcount];
    if ([model.votostate isEqualToString:@"0"]) {
        
        self.tagLal.text = [NSString stringWithFormat:@" 投票中... "];
        self.tagLal.textColor = NEW_RED_COLOR;
        [self.tagLal.layer setBorderWidth:1];
        [self.tagLal.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        
    }else if ([model.votostate isEqualToString:@"-1"]){
        
        self.tagLal.text = [NSString stringWithFormat:@" 已结束 "];
        self.tagLal.textColor = [UIColor blackColor];
        [self.tagLal.layer setBorderWidth:1];
        [self.tagLal.layer setBorderColor:CGColorRetain([UIColor blackColor].CGColor)];
        
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
    
    float width = SCREEN_WIDTH - 2 * 10 - 2 * 13  - 10 - 10 - 40 - 3 - 16 - 8;
    
    if (red1 == 0) {
        
        self.red1ViewLayout.constant = 0;
        self.red2ViewLayout.constant = 0;
    }else if (red1 > 0 && red2 == 0){
        
        self.red1ViewLayout.constant = width;
        self.red2ViewLayout.constant = 0;
    }else{
        
        self.red1ViewLayout.constant = width;
        self.red2ViewLayout.constant = width / red1 * red2;
    }

    float height = 284;
    
    model.height = height;
    
}

- (IBAction)cityTouch:(id)sender {
    
    if (self.cityButtonDidClickBlock) {
        
        self.cityButtonDidClickBlock(0);
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
