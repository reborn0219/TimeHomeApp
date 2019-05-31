//
//  BBSCommodity2TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSCommodity2TableViewCell.h"

#import "ImageUitls.h"

@interface BBSCommodity2TableViewCell ()

/** 右上角的线和label */
@property (nonatomic, strong) UIView *rightToplineView;
@property (nonatomic, strong) UILabel *rightTopLabel;

@end

@implementation BBSCommodity2TableViewCell

- (void)setRightTopStyle:(NSInteger)rightTopStyle {
    _rightTopStyle = rightTopStyle;
    
    if (rightTopStyle == 1) {
        _redPaperLayout.constant = 0;
        
        _rightToplineView.hidden = NO;
        _rightTopLabel.hidden = NO;
        
        _rightTopLabel.text = [XYString isBlankString:_model.tonow] ? @"" : [NSString stringWithFormat:@"%@后下架",_model.tonow];
        _rightTopLabel.textColor = kNewRedColor;
        
        
    }else if (rightTopStyle == 2) {
        _redPaperLayout.constant = 0;
        
        _rightToplineView.hidden = NO;
        _rightTopLabel.hidden = NO;
        
        _rightTopLabel.text = @"已下架";
        _rightTopLabel.textColor = TITLE_TEXT_COLOR;
        
    }else {
        _rightToplineView.hidden = YES;
        _rightTopLabel.hidden = YES;
    }
}


- (void)setModel:(BBSModel *)model {
    
    _model = model;
    
    CGSize size;
    size = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10 - 47 - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    if(size.height > 36.0){
        
        size.height = 36;
    }
    
    self.infoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.title]];
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
    self.tagLal.layer.cornerRadius = 8;
    self.tagLal.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [self.tagLal.layer setBorderWidth:1];
    [self.tagLal.layer setBorderColor:CGColorRetain(NEW_BLUE_COLOR.CGColor)];
    self.moneyLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.goodsprice]];
    
    NSArray *imgArr = model.piclist;
    
    NSDictionary *dict1 = imgArr[0];
    NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image1 withName:url1];
    
    NSDictionary *dict2 = imgArr[1];
    NSString *url2 = [NSString stringWithFormat:@"%@",dict2[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image2 withName:url2];
    
    if(self.type == 2){
        
        self.headView.image = [UIImage imageNamed:@"邻趣-首页-帖子-定位图标"];
        self.headView.contentMode = UIViewContentModeCenter;
        
        self.nameLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.communityname]];
        self.nameLal.textColor = NEW_BLUE_COLOR;
    }else{
        
        self.headView.contentMode = UIViewContentModeScaleToFill;
        [self.headView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:PLACEHOLDER_IMAGE];
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
    
    self.commentLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.commentcount]];
    self.praiseLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]];
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
    
    float height = 13 + 47 + 5 + size.height + 5 + 10 + 18 + 8 + 1 + 15 + 20 + 15 + 10 + (SCREEN_WIDTH - 20 - 10 - 2 * 8) / 2;
    
    model.height = height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!_rightToplineView) {
        _rightToplineView = [[UIView alloc] init];
        _rightToplineView.backgroundColor = kNewRedColor;
        [self.contentView addSubview:_rightToplineView];
        [_rightToplineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@1);
            make.height.equalTo(@15);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.tagLal.mas_centerY);
            
        }];
    }
    
    if (!_rightTopLabel) {
        _rightTopLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_rightTopLabel];
        _rightTopLabel.text = @"";
        _rightTopLabel.font = DEFAULT_FONT(14);
        _rightTopLabel.textColor = kNewRedColor;
        [_rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_rightToplineView.mas_centerY);
            make.right.equalTo(_rightToplineView).offset(-5);
            
        }];
    }
    
    _rightToplineView.hidden = YES;
    _rightTopLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
