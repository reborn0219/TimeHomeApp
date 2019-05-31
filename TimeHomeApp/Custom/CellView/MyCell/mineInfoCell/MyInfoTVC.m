//
//  MyInfoTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyInfoTVC.h"
#import "THAgeView.h"

@interface MyInfoTVC ()

@property (nonatomic, strong) UIButton *headImageButton;//头像
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *mobileLabel;//电话
@property (nonatomic, strong) UILabel *rankLabel;//等级
@property (nonatomic, strong) UILabel *addressLabel;//地址
@property (nonatomic, strong) THAgeView *ageView;//年龄

@end

@implementation MyInfoTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUp];
        
    }
    return self;
}
- (void)setUp {
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headImageButton];
    _headImageButton.layer.cornerRadius = 35;
    _headImageButton.clipsToBounds = YES;
    [_headImageButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(70));
        make.height.equalTo(@(70));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = DEFAULT_FONT(15);
    _nameLabel.textColor = TITLE_TEXT_COLOR;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headImageButton.mas_right).offset(WidthSpace(26));
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(_headImageButton);
        
    }];
    
    _mobileLabel = [[UILabel alloc]init];
    _mobileLabel.font = [UIFont systemFontOfSize:13.f];
    _mobileLabel.textAlignment = NSTextAlignmentLeft;
    _mobileLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_mobileLabel];
    [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(_headImageButton.mas_centerY);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
        
    }];

    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mobileLabel.mas_right).offset(1);
        make.height.equalTo(@26);
        make.width.equalTo(@1);
        make.centerY.equalTo(_mobileLabel.mas_centerY);
    }];

    UIImageView *lvImage = [[UIImageView alloc]init];
    lvImage.image = [UIImage imageNamed:@"用户等级_lv_大"];
    [self.contentView addSubview:lvImage];
    [lvImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line2.mas_right).offset(10);
        make.width.equalTo(@(WidthSpace(50)));
        make.height.equalTo(@(WidthSpace(30)));
        make.centerY.equalTo(_mobileLabel.mas_centerY);
    }];

    _rankLabel = [[UILabel alloc]init];
    _rankLabel.font = [UIFont systemFontOfSize:12.f];
    _rankLabel.textAlignment = NSTextAlignmentLeft;
    _rankLabel.textColor = UIColorFromRGB(0X645E5E);
    [self.contentView addSubview:_rankLabel];
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lvImage.mas_right).offset(0);
        make.bottom.equalTo(lvImage.mas_bottom).offset(0.5);
        make.width.equalTo(@50);
        make.height.equalTo(@10);
    }];

    _ageView = [[THAgeView alloc]init];
    [self.contentView addSubview:_ageView];
    [_ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mobileLabel.mas_left);
        make.bottom.equalTo(_headImageButton.mas_bottom);
        make.height.equalTo(@14);
        make.width.equalTo(@46);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.font = [UIFont systemFontOfSize:13];
    _addressLabel.textColor = TITLE_TEXT_COLOR;
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ageView.mas_right).offset(WidthSpace(14));
        make.centerY.equalTo(_ageView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
}
//头像点击
- (void)headButtonClick {
    
    if (self.headClick) {
        self.headClick();
    }
    
}
//传个人信息model
- (void)setModel:(UserData *)model {
    _model = model;
    
    [_headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
    if (![XYString isBlankString:model.nickname]) {
        _nameLabel.text = model.nickname;
    }
    if (![XYString isBlankString:model.phone]) {
        _mobileLabel.text = model.phone;
    }
    if (![XYString isBlankString:model.level]) {
        _rankLabel.text = [NSString stringWithFormat:@"%@",model.level];
    }
    if ([model.sex intValue] == 1) {
        //男
        _ageView.ageImage.image = [UIImage imageNamed:@"邻圈_男"];
        _ageView.backgroundColor = MAN_COLOR;

    }else if ([model.sex intValue] == 2) {
        //女
        _ageView.ageImage.image = [UIImage imageNamed:@"邻圈_女"];
        _ageView.backgroundColor = WOMEN_COLOR;

    }else {
        //其他
        _ageView.ageImage.image = [UIImage imageNamed:@""];
        _ageView.backgroundColor = [UIColor whiteColor];
    }
    //
    if (![XYString isBlankString:model.age]) {
        _ageView.age = [NSString stringWithFormat:@"%@",model.age];
    }
    NSString *communityname = @"";
    if (![XYString isBlankString:model.communityname]) {
        communityname = [communityname stringByAppendingFormat:@"%@",model.communityname];
    }

    if (![XYString isBlankString:model.building]) {
        communityname = [communityname stringByAppendingFormat:@" %@",model.building];
    }

    _addressLabel.text = communityname;

}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
