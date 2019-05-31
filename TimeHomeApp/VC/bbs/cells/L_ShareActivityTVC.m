//
//  L_ShareActivityTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ShareActivityTVC.h"
#import "ImageUitls.h"

@implementation L_ShareActivityTVC

- (void)setModel:(BBSModel *)model {
    _model = model;
    
    /** 标题 */
    NSString *titleString = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.title]];
    self.title_Label.text = titleString;
    
    /** 内容 */
    NSString *contentString = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
    self.detail_Label.text = contentString;

    /** 图片 */
    NSArray *imgArr = model.piclist;
    if (imgArr.count > 0) {
        
        NSDictionary *dict1 = imgArr[0];
        NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
//        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:PLACEHOLDER_IMAGE];
        [ImageUitls saveAndShowImage:_leftImageView withName:url1];

    }else {
        
        _leftImageView.image = PLACEHOLDER_IMAGE;
        
    }
    
    /** 头像 */
    self.header_ImageView.contentMode = UIViewContentModeScaleToFill;
    [self.header_ImageView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:kHeaderPlaceHolder];
    self.header_ImageView.layer.cornerRadius = 10;
    self.header_ImageView.layer.masksToBounds = YES;
    /** 昵称 */
    self.nickName_Label.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.nickname]];
    self.nickName_Label.textColor = UIColorFromRGB(0x595353);
    
    
    /** 发布时间 */
    self.time_Label.text = [XYString IsNotNull:model.releasetime];
    
    /** 社区名称 */
    self.community_Label.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.communityname]];
    self.community_Label.textColor = NEW_BLUE_COLOR;

    /** 点赞个数 */
    if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]] isEqualToString:@""]) {
        self.dianzan_Label.text = @"0";
    }else{
        self.dianzan_Label.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]];
    }
    
    /** 是否点赞图片 */
    if (model.ispraise.integerValue == 0) {
        
        _praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
        
    }else {
        
        _praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
        
    }
    
    if (_cellType == 2) {
        _time_Label.hidden = YES;
        _dingweiImageView_WidthLayout.constant = 0;
        _dingwei_ImageView.hidden = YES;
        
        self.community_Label.text = [XYString IsNotNull:model.releasetime];
        self.community_Label.textColor = TEXT_COLOR;
    }else {
        _time_Label.hidden = NO;
        _dingweiImageView_WidthLayout.constant = 20;
        _dingwei_ImageView.hidden = NO;
        /** 社区名称 */
        self.community_Label.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.communityname]];
        self.community_Label.textColor = NEW_BLUE_COLOR;
    }
    
    if ([XYString isBlankString:self.detail_Label.text]) {
        _topContentHeight_Layout.constant = 173. - 47.;
        model.height = 250. - 47.;
    }else {
        _topContentHeight_Layout.constant = 173.;
        model.height = 250.;
    }
    
    
}

- (IBAction)allButtonsDidClick:(UIButton *)sender {
    
    if (sender.tag == 3 && _cellType == 2) {
        return;
    }
    
    //1.头像 2.点赞 3.社区
    if (self.cellBtnDidClickBlock) {
        self.cellBtnDidClickBlock(nil, nil, sender.tag);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    // 注意：如果在XIB中有动态计算高度的Label 要写一下代码：（以确保正确计算label 的高度）
    _title_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 20 - 8 - 152 - 30;
    _detail_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 20 - 8 - 152 - 30;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
