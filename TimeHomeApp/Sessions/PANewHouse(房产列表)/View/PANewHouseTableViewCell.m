//
//  PANewHouseTableViewCell.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHouseTableViewCell.h"

@interface PANewHouseTableViewCell ()
@property (nonatomic, strong)UIImageView * houseImageView;
@property (nonatomic, strong)UILabel * communityNameLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIImageView * authImageView;

@property (nonatomic, strong)UIImageView * buildingImageView;//楼栋单元号
@property (nonatomic, strong)UILabel *buildingLabel;

@property (nonatomic, strong)UIImageView *phoneImageView;
@property (nonatomic, strong)UILabel *phoneLabel;

@end

@implementation PANewHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    self.backgroundColor = UIColorHex(0xF5F5F5);
    UIView * whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    [self.contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(13);
        make.right.equalTo(self.contentView).with.offset(-13);
        make.bottom.equalTo(self.contentView);
    }];
    
    UIView * blueView = [[UIView alloc]init];
    blueView.backgroundColor = UIColorHex(0x85B8F2);
    [blueView addSubview:self.houseImageView];
    blueView.layer.cornerRadius = 20;
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(blueView);
    }];
    [whiteView addSubview:blueView];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).with.offset(10);
        make.left.equalTo(whiteView).with.offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [whiteView addSubview:self.communityNameLabel];
    [whiteView addSubview:self.addressLabel];
    [whiteView addSubview:self.authImageView];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorHex(0xEFEFEF);
    [whiteView addSubview:line];
    
    [whiteView addSubview:self.buildingImageView];
    [whiteView addSubview:self.buildingLabel];
    
    [whiteView addSubview:self.phoneLabel];
    [whiteView addSubview:self.phoneImageView];
    
    [self.communityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueView.mas_right).with.offset(2);
        make.top.equalTo(whiteView).with.offset(13);
    }];
    
    [self.authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView);
        make.right.equalTo(whiteView).with.offset(-24);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.communityNameLabel);
        make.top.equalTo(self.communityNameLabel.mas_bottom).with.offset(8);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).with.offset(10);
        make.right.equalTo(whiteView).with.offset(-10);
        make.top.equalTo(blueView.mas_bottom).with.offset(13);
        make.height.equalTo(@1);
    }];
    
    [self.buildingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).with.offset(12);
    }];
    [self.buildingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buildingImageView);
        make.left.equalTo(self.buildingImageView.mas_right).with.offset(4);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line);
        make.centerY.equalTo(self.buildingImageView);
    }];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buildingImageView);
        make.right.equalTo(self.phoneLabel.mas_left).with.offset(-4);
    }];
}

- (UIImageView *)houseImageView{
    if (!_houseImageView) {
        _houseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wdfc_icon_home_n"]];
    }
    return _houseImageView;
}
- (UILabel *)communityNameLabel{
    if (!_communityNameLabel) {
        _communityNameLabel = [[UILabel alloc]init];
        _communityNameLabel.textColor = UIColorHex(0x000000);
        _communityNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _communityNameLabel;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = UIColorHex(0x6D6C6E);
        _addressLabel.font = [UIFont systemFontOfSize:11];
    }
    return _addressLabel;
}
- (UIImageView *)authImageView{
    if (!_authImageView) {
        _authImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wdfc_icon_approve_n"]];
    }
    return _authImageView;
}
- (UIImageView *)buildingImageView{
    if (!_buildingImageView) {
        _buildingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wdfc_icon_house_n"]];
    }
    return _buildingImageView;
}
- (UILabel *)buildingLabel{
    if (!_buildingLabel) {
        _buildingLabel = [[UILabel alloc]init];
        _buildingLabel.textColor = UIColorHex(0x6D6C6E);
        _buildingLabel.font = [UIFont systemFontOfSize:14];
    }
    return _buildingLabel;
}
- (UIImageView *)phoneImageView{
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wdfc_icon_phone_n"]];
    }
    return _phoneImageView;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = UIColorHex(0x6D6C6E);
        _phoneLabel.font = [UIFont systemFontOfSize:14];
    }
    return _phoneLabel;
}

- (void)setHouseModel:(PANewHouseModel *)houseModel{
    if (_houseModel != houseModel) {
        _houseModel = houseModel;
    }
    self.communityNameLabel.text = houseModel.communityName;
    self.addressLabel.text = houseModel.houseAddress;
    self.buildingLabel.text = houseModel.houseRoom;
    self.phoneLabel.text = houseModel.contactMobile;
}

@end
