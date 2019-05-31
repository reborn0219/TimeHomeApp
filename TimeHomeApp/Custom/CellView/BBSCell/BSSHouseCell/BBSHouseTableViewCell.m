//
//  BBSHouseTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSHouseTableViewCell.h"

#import "ImageUitls.h"

@interface BBSHouseTableViewCell ()

/** 右上角的线和label */
@property (nonatomic, strong) UIView *rightToplineView;
@property (nonatomic, strong) UILabel *rightTopLabel;

@end

@implementation BBSHouseTableViewCell

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
    size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 8 - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    if(size.height > 36.0){
        
        size.height = 36;
    }
    
    if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]] isEqualToString:@""]) {
        
        size.height = 0.0;
    }
    
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
        
        self.redPaperLayout.constant = 0;
        self.redPaper.image = [UIImage imageNamed:@""];
    }
    
    float unitCount = 0;
    self.unitLayout.constant = 0;
    self.unitlal.hidden = YES;
    
    if ([model.housetype isEqualToString:@"10"]) {//房产出售
        
        self.tag1Lal.text = @"  • 房产  ";
        self.tag2Lal.text = @"  出售  ";
        self.tag2Lal.textColor = [UIColor blackColor];
        [self.tag2Lal.layer setBorderWidth:1];
        [self.tag2Lal.layer setBorderColor:CGColorRetain([UIColor blackColor].CGColor)];
        self.pointHide.hidden = NO;
        self.otherLal.hidden = NO;
        self.otherLalLayout.constant = 54;
        
        NSString *areaStr = [NSString stringWithFormat:@"%.2f",model.area];
        if ([[XYString IsNotNull:areaStr] isEqualToString:@""]) {
            
            self.squareLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"0㎡"]];
        }else{
            
            self.squareLal.text = [NSString stringWithFormat:@"%@㎡",@(areaStr.doubleValue)];
        }
        
        self.roomNoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@室%@厅%@卫",model.bedroom,model.livingroom,model.toilef]];
        
        self.otherLal.text = [NSString stringWithFormat:@"%@/%@层",[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.floornum]],[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.allfloornum]]];
        //        if ([model.decorattype isEqualToString:@"1"]) {
        //
        //            self.otherLal.text = [NSString stringWithFormat:@"拎包入住"];
        //        }else if ([model.decorattype isEqualToString:@"2"]){
        //
        //            self.otherLal.text = [NSString stringWithFormat:@"简装"];
        //        }
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.money]] isEqualToString:@""]) {
            
            self.moneyLal.text = [NSString stringWithFormat:@"0元"];
        }else{
            
            NSString *moneyStr = [NSString stringWithFormat:@"%@",model.money];
            NSArray *array = [moneyStr componentsSeparatedByString:@"."];
            NSString *totalStr = array[0];
            if (totalStr.length >= 5) {
                
                NSString * lead = [totalStr substringToIndex:totalStr.length - 4];
                NSString * tail = [totalStr substringWithRange:NSMakeRange(totalStr.length - 4, 1)];
                if ([tail integerValue] >= 5) {
                    
                    lead = [NSString stringWithFormat:@"%li",[lead integerValue] + 1];
                }
                //[totalStr substringFromIndex:totalStr.length - 4];
                self.moneyLal.text = [NSString stringWithFormat:@"%@万元",lead];
            }else{
                
                self.moneyLal.text = [NSString stringWithFormat:@"%@元",moneyStr];
            }
        }
        self.unitLayout.constant = 15.0;
        self.unitlal.hidden = NO;
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            self.unitlal.text = [NSString stringWithFormat:@"0元/㎡"];
        }else{
            
            self.unitlal.text = [NSString stringWithFormat:@"%@元/㎡",@(priceStr.doubleValue)];
        }
        unitCount = 15.0;
    }else if ([model.housetype isEqualToString:@"11"]){//房产出租
        
        self.tag1Lal.text = @"  • 房产  ";
        self.tag2Lal.text = @"  出租  ";
        self.tag2Lal.textColor = TITLE_TEXT_COLOR;
        [self.tag2Lal.layer setBorderWidth:1];
        [self.tag2Lal.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
        self.pointHide.hidden = NO;
        self.otherLal.hidden = NO;
        self.otherLalLayout.constant = 54;
        
        NSString *areaStr = [NSString stringWithFormat:@"%.2f",model.area];
        if ([[XYString IsNotNull:areaStr] isEqualToString:@""]) {
            
            self.squareLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"0㎡"]];
        }else{
            
            self.squareLal.text = [NSString stringWithFormat:@"%@㎡",@(areaStr.doubleValue)];
        }
        
        self.roomNoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@室%@厅%@卫",model.bedroom,model.livingroom,model.toilef]];
        if ([model.decorattype isEqualToString:@"1"]) {
            
            self.otherLal.text = [NSString stringWithFormat:@"拎包入住"];
        }else if ([model.decorattype isEqualToString:@"2"]){
            
            self.otherLal.text = [NSString stringWithFormat:@"简单装修"];
        }else{
            
            self.otherLal.text = [NSString stringWithFormat:@""];
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            self.moneyLal.text = [NSString stringWithFormat:@"0元/月"];
        }else{
            
            self.moneyLal.text = [NSString stringWithFormat:@"%@元/月",@(priceStr.doubleValue)];
        }
        
        self.unitLayout.constant = 0;
        unitCount = 0;
    }else if ([model.housetype isEqualToString:@"30"]){//车位出售
        
        self.tag1Lal.text = @"  • 车位  ";
        self.tag2Lal.text = @"  出售  ";
        self.tag2Lal.textColor = [UIColor blackColor];
        [self.tag2Lal.layer setBorderWidth:1];
        [self.tag2Lal.layer setBorderColor:CGColorRetain([UIColor blackColor].CGColor)];
        self.pointHide.hidden = YES;
        self.otherLal.hidden = YES;
        self.otherLalLayout.constant = 0;
        if ([model.underground isEqualToString:@"0"]) {
            
            self.squareLal.text = [NSString stringWithFormat:@"地上车位"];
        }else if ([model.underground isEqualToString:@"1"]){
            
            self.squareLal.text = [NSString stringWithFormat:@"地下车位"];
        }
        
        if ([model.fixed isEqualToString:@"0"]) {
            
            self.roomNoLal.text = [NSString stringWithFormat:@"非固定"];
        }else if ([model.fixed isEqualToString:@"1"]){
            
            self.roomNoLal.text = [NSString stringWithFormat:@"固定"];
        }
        
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%0.2f",model.price]] isEqualToString:@""]) {
            
            self.moneyLal.text = [NSString stringWithFormat:@"0元"];
        }else{
            
            NSString *moneyStr = [NSString stringWithFormat:@"%0.2f",model.price];
            NSArray *array = [moneyStr componentsSeparatedByString:@"."];
            NSString *totalStr = array[0];
            if (totalStr.length >= 5) {
                
                NSString * lead = [totalStr substringToIndex:totalStr.length - 4];
                NSString * tail = [totalStr substringWithRange:NSMakeRange(totalStr.length - 4, 1)];
                if ([tail integerValue] >= 5) {
                    
                    lead = [NSString stringWithFormat:@"%li",[lead integerValue] + 1];
                }
                //[totalStr substringFromIndex:totalStr.length - 4];
                self.moneyLal.text = [NSString stringWithFormat:@"%@万元",lead];
            }else{
                
                self.moneyLal.text = [NSString stringWithFormat:@"%@元",moneyStr];
            }
        }
        self.unitLayout.constant = 0;
        unitCount = 0;
    }else if ([model.housetype isEqualToString:@"31"]){//车位出租
        
        self.tag1Lal.text = @"  • 车位  ";
        self.tag2Lal.text = @"  出租  ";
        self.tag2Lal.textColor = TITLE_TEXT_COLOR;
        [self.tag2Lal.layer setBorderWidth:1];
        [self.tag2Lal.layer setBorderColor:CGColorRetain(TITLE_TEXT_COLOR.CGColor)];
        self.pointHide.hidden = YES;
        self.otherLal.hidden = YES;
        self.otherLalLayout.constant = 0;
        if ([model.underground isEqualToString:@"0"]) {
            
            self.squareLal.text = [NSString stringWithFormat:@"地上车位"];
        }else if ([model.underground isEqualToString:@"1"]){
            
            self.squareLal.text = [NSString stringWithFormat:@"地下车位"];
        }
        
        if ([model.fixed isEqualToString:@"0"]) {
            
            self.roomNoLal.text = [NSString stringWithFormat:@"非固定"];
        }else if ([model.fixed isEqualToString:@"1"]){
            
            self.roomNoLal.text = [NSString stringWithFormat:@"固定"];
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            self.moneyLal.text = [NSString stringWithFormat:@"0元/月"];
        }else{
            
            self.moneyLal.text = [NSString stringWithFormat:@"%@元/月",@(priceStr.doubleValue)];
        }
        
        self.unitLayout.constant = 0;
        unitCount = 0;
    }else{
        
        self.tag1Lal.text = @"  • 房产  ";
        self.tag2Lal.text = @"  出租  ";
        self.pointHide.hidden = NO;
        self.otherLal.hidden = NO;
        
        self.squareLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%0.2f㎡",model.area]];
        self.roomNoLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@室%@厅%@卫",model.bedroom,model.livingroom,model.toilef]];
        if ([model.decorattype isEqualToString:@"1"]) {
            
            self.otherLal.text = [NSString stringWithFormat:@"拎包入住"];
        }else if ([model.decorattype isEqualToString:@"2"]){
            
            self.otherLal.text = [NSString stringWithFormat:@"简单装修"];
        }else{
            
            self.otherLal.text = [NSString stringWithFormat:@""];
        }
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.money]] isEqualToString:@""]) {
            
            self.moneyLal.text = [NSString stringWithFormat:@"￥0"];
        }else{
            
            self.moneyLal.text = [NSString stringWithFormat:@"￥%@",model.money];
        }
        self.unitLayout.constant = 0;
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%0.2f",model.price]] isEqualToString:@""]) {
            
            self.unitlal.text = [NSString stringWithFormat:@"0/平米"];
        }else{
            
            self.unitlal.text = [NSString stringWithFormat:@"%0.2f/平米",model.price];
        }
        unitCount = 0;
    }
    
    self.tag1Lal.layer.cornerRadius = 8;
    self.tag1Lal.layer.masksToBounds = YES;
    [self.tag1Lal.layer setBorderWidth:1];
    [self.tag1Lal.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
    self.tag2Lal.layer.cornerRadius = 8;
    self.tag2Lal.layer.masksToBounds = YES;
    
    NSArray *imgArr = model.piclist;
    
    NSDictionary *dict1 = imgArr[0];
    NSString *url1 = [NSString stringWithFormat:@"%@",dict1[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image1 withName:url1];
    
    NSDictionary *dict2 = imgArr[1];
    NSString *url2 = [NSString stringWithFormat:@"%@",dict2[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image2 withName:url2];
    
    NSDictionary *dict3 = imgArr[2];
    NSString *url3 = [NSString stringWithFormat:@"%@",dict3[@"picurl"]];
    [ImageUitls saveAndShowImage:self.image3 withName:url3];
    
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
    
    float height = 13 + 47 + 5 + size.height + 5 + 10 + 18 + 8 + 1 + 10 + 20 + 10 + 10 + 20 + 5 + unitCount + (SCREEN_WIDTH - 20 - 2 * 10 - 2 * 8) / 3;
    
    model.height = height - 1;
}

/**
 点赞
 */
- (IBAction)l_praiseButtonDidTouch:(UIButton *)sender {
    
    NSLog(@"点赞");
    if (_model.ispraise.integerValue == 0) {

        if (self.praiseButtonDidClickBlock) {
            self.praiseButtonDidClickBlock(0);
        }
        
    }else {
        
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
            make.centerY.equalTo(self.tag1Lal.mas_centerY);
            
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

- (IBAction)houseOrCarTap:(UIButton *)sender {
    
    NSLog(@"房产车位点击");
    if ([_model.housetype isEqualToString:@"10"] || [_model.housetype isEqualToString:@"11"]) {
        /** 房产 */
        if (self.houseOrCarDidClickBlock) {
            self.houseOrCarDidClickBlock(0);
        }
        
    }else if ([_model.housetype isEqualToString:@"30"] || [_model.housetype isEqualToString:@"31"]) {
        /** 车位 */
        if (self.houseOrCarDidClickBlock) {
            self.houseOrCarDidClickBlock(1);
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
