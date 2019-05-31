//
//  PASuggestRecordTableViewCell.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestRecordTableViewCell.h"

@interface PASuggestRecordTableViewCell ()
@property (nonatomic, strong)UIImageView * communityImageView;
@property (nonatomic, strong)UILabel * communityNameLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UILabel * suggestInfoLabel;
@property (nonatomic, strong)UIImageView * rightImageView;
@end

@implementation PASuggestRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    [self.contentView addSubview:self.communityImageView];
    [self.contentView addSubview:self.communityNameLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.suggestInfoLabel];
    
    [self.communityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(13);
        make.top.equalTo(self.contentView).with.offset(14);
    }];
    [self.communityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.communityImageView);
        make.left.equalTo(self.communityImageView.mas_right).with.offset(4);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.communityImageView);
        make.top.equalTo(self.communityImageView.mas_bottom).with.offset(9);
    }];
    [self.suggestInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.timeLabel);
        make.right.equalTo(self.contentView).with.offset(-13);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-13);
    }];
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorHex(0xEFEFEF);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Lazyload
- (UIImageView *)communityImageView{
    if (!_communityImageView) {
        _communityImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tsjl_icon_building_n"]];
    }
    return _communityImageView;
}
- (UILabel *)communityNameLabel{
    if (!_communityNameLabel) {
        _communityNameLabel = [[UILabel alloc]init];
        _communityNameLabel.textColor = UIColorHex(0x000000);
        _communityNameLabel.font = [UIFont systemFontOfSize:16];
        _communityNameLabel.text = @"恒基现代城";
    }
    return _communityNameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = UIColorHex(0x9B9B9B);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"2018-05-02 16:25:22";
    }
    return _timeLabel;
}
- (UILabel *)suggestInfoLabel{
    if (!_suggestInfoLabel) {
        _suggestInfoLabel = [[UILabel alloc]init];
        _suggestInfoLabel.textColor = UIColorHex(0x4A4A4A);
        _suggestInfoLabel.font = [UIFont systemFontOfSize:14];
        _suggestInfoLabel.numberOfLines = 1;
        _suggestInfoLabel.text = @"13号楼每天晚上音乐声音太大，麻烦物业出面…";
    }
    return _suggestInfoLabel;
}
- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tsjl_icon_details_n@2x"]];
    }
    return _rightImageView;
    return _rightImageView;
}

- (void)setSuggestModel:(PASuggestListModel *)suggestModel{
    if (_suggestModel != suggestModel) {
        _suggestModel = suggestModel;
    }
    self.communityNameLabel.text = suggestModel.communityName;
    self.timeLabel.text = suggestModel.createTime;
    self.suggestInfoLabel.text = suggestModel.complaintDetails;
}

@end
