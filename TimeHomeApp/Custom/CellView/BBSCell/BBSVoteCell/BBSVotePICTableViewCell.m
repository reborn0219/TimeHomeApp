//
//  BBSVotePICTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSVotePICTableViewCell.h"

#import "ImageUitls.h"

@implementation BBSVotePICTableViewCell

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
        self.redPaper.image = [UIImage imageNamed:@""];
    }
    
    NSArray *imgArr = model.itemlist;
    
    NSDictionary *dict1 = imgArr[0];
    NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image1 withName:url1];
    
    NSDictionary *dict2 = imgArr[1];
    NSString *url2 = [NSString stringWithFormat:@"%@",dict2[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image2 withName:url2];
    
    NSDictionary *dict3 = imgArr[2];
    NSString *url3 = [NSString stringWithFormat:@"%@",dict3[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image3 withName:url3];
    
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
    
    self.number.text = [NSString stringWithFormat:@"共%@项投票",model.itemcount];
    if ([model.votostate isEqualToString:@"0"]) {
        
        self.tagLal.text = [NSString stringWithFormat:@"  投票中...  "];
        self.tagLal.textColor = NEW_RED_COLOR;
        [self.tagLal.layer setBorderWidth:1];
        [self.tagLal.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];

    }else if ([model.votostate isEqualToString:@"-1"]){
        
        self.tagLal.text = [NSString stringWithFormat:@"  已结束  "];
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
    
    float height = 13 + 47 + 5 + 8 + 18 + 8 + 1 + 15 + 20 + 15 + 10 + (SCREEN_WIDTH - 20 - 2 * 10 - 2 * 8) / 3;
    
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
