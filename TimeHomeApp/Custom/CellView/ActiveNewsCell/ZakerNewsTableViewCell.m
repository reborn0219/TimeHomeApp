//
//  ZakerNewsTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZakerNewsTableViewCell.h"
#import "PANewHomeNewsModel.h"
@implementation ZakerNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewsModel:(PANewHomeNewsModel *)newsModel{
    if (_newsModel != newsModel) {
        _newsModel = newsModel;
    }
    self.titleLal.text   = _newsModel.title;
    self.timeLal.text = _newsModel.date;
    self.fromLal.text = _newsModel.author;
    NSString * picStr =_newsModel.thumbnailpic;
    
    if(![XYString isBlankString:picStr])
    {
        [self.logoImg sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"默认图"]];
    } else {
        [self.logoImg setImage:[UIImage imageNamed:@"默认图"]];
    }

}
@end
