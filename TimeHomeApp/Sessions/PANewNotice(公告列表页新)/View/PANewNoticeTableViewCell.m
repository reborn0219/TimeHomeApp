//
//  PANewNoticeTableViewCell.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewNoticeTableViewCell.h"
#import "PANewNoticeURL.h"
@interface PANewNoticeTableViewCell ()
@property (nonatomic, strong)UIView * whiteView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView * noticeImageView;
@property (nonatomic, strong)UILabel * noticeInfoLabel;
@property (nonatomic, strong)UILabel *unreadTagLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIImageView *readImageView;
@property (nonatomic, strong)UILabel * readCountLabel;
@property (nonatomic, strong)UIView * line;

@end

@implementation PANewNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    self.contentView.backgroundColor = UIColorHex(0xF5F5F5);
    self.noticeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.whiteView];
    [self.whiteView addSubview:self.titleLabel];
    [self.whiteView addSubview:self.noticeImageView];
    [self.whiteView addSubview:self.noticeInfoLabel];
    [self.whiteView addSubview:self.unreadTagLabel];
    [self.whiteView addSubview:self.timeLabel];
    [self.whiteView addSubview:self.readImageView];
    [self.whiteView addSubview:self.readCountLabel];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14);
        make.right.equalTo(self.contentView).with.offset(-14);
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-7);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).with.offset(10);
        make.right.equalTo(self.whiteView).with.offset(-10);
        make.top.equalTo(self.whiteView).with.offset(7);
    }];
    UIImage * image = [UIImage imageNamed:@"tsjy_icon_emptyimg_n"];
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16);
        make.right.equalTo(self.whiteView).with.offset(-10);
        //make.height.mas_equalTo(image.size.height);
        make.height.equalTo(@186);
    }];
    self.noticeImageView.image = image;
    
    [self.noticeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).with.offset(10);
        make.right.equalTo(self.whiteView).with.offset(-10);
        make.top.equalTo(self.noticeImageView.mas_bottom).with.offset(16);
    }];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = UIColorHex(0xEFEFEF);
    [self.whiteView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).with.offset(10);
        make.right.equalTo(self.whiteView).with.offset(-10);
        make.top.equalTo(self.noticeInfoLabel.mas_bottom).with.offset(16);
        make.height.equalTo(@1);
    }];
    
    [self.unreadTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.line.mas_bottom).with.offset(8);
        make.width.equalTo(@44);
        make.height.equalTo(@20);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unreadTagLabel.mas_right).with.offset(8);
        make.centerY.equalTo(self.unreadTagLabel);
    }];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.unreadTagLabel);
        make.right.equalTo(self.whiteView).with.offset(-10);
    }];
    [self.readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.unreadTagLabel);
        make.right.equalTo(self.readCountLabel.mas_left).with.offset(-4);
    }];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.readImageView.mas_bottom).with.offset(11);
    }];
}

#pragma mark - Lazyload

- (UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 4;
    }
    return _whiteView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorHex(0x000000);
        _titleLabel.text = @"显示本社区公告已阅读人数，此消息是否已阅读状态和公告发布时间。";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIImageView *)noticeImageView{
    if (!_noticeImageView) {
        _noticeImageView = [[UIImageView alloc]init];
    }
    return _noticeImageView;
}
- (UILabel *)noticeInfoLabel{
    if (!_noticeInfoLabel) {
        _noticeInfoLabel = [[UILabel alloc]init];
        _noticeInfoLabel.textColor = UIColorHex(0x949494);
        _noticeInfoLabel.font = [UIFont systemFontOfSize:14];
        _noticeInfoLabel.numberOfLines = 2;
        _noticeInfoLabel.text = @"";
    }
    return _noticeInfoLabel;
}
- (UILabel *)unreadTagLabel{
    if (!_unreadTagLabel) {
        _unreadTagLabel = [[UILabel alloc]init];
        _unreadTagLabel.font = [UIFont systemFontOfSize:12];
        _unreadTagLabel.textColor = UIColorHex(0xFFFFFF);
        _unreadTagLabel.backgroundColor = UIColorHex(0x999B9E);
        _unreadTagLabel.text = @"已读";
        _unreadTagLabel.textAlignment = 1;
        _unreadTagLabel.layer.cornerRadius = 2;
    }
    return _unreadTagLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = UIColorHex(0x999B9E);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"2018/06/07 05:51";
    }
    return _timeLabel;
}
- (UIImageView *)readImageView{
    if (!_readImageView) {
        _readImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sqgg_icon_read_n@2x"]];
    }
    return _readImageView;
}
- (UILabel *)readCountLabel{
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc]init];
        _readCountLabel.textColor = UIColorHex(0x999B9E);
        _readCountLabel.font = [UIFont systemFontOfSize:12];
        _readCountLabel.text = @"203";
    }
    return _readCountLabel;
}

- (void)setNoticeModel:(PANewNoticeModel *)noticeModel{
    if (_noticeModel != noticeModel) {
        _noticeModel = noticeModel;
    }
    self.noticeInfoLabel.text =noticeModel.noticeContent;
    self.titleLabel.text = noticeModel.title;
    self.timeLabel.text = noticeModel.noticeTime;
    self.readCountLabel.text = noticeModel.readNum;
    if (noticeModel.isRead) {
        self.unreadTagLabel.backgroundColor = UIColorHex(0x999B9E);
        self.unreadTagLabel.text = @"已读";
    } else {
        self.unreadTagLabel.backgroundColor = UIColorHex(0x4A90E2);
        self.unreadTagLabel.text = @"未读";
    }
    
    if (noticeModel.attachmentIds.count >0) {
        
        [self.noticeInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteView).with.offset(10);
            make.right.equalTo(self.whiteView).with.offset(-10);
            make.top.equalTo(self.noticeImageView.mas_bottom).with.offset(16);
        }];
        
        self.noticeImageView.hidden = NO;
        NSURL * imageUrl;
        if ([noticeModel.attachmentIds[0] hasPrefix:@"http://"]) {
            imageUrl = [NSURL URLWithString:noticeModel.attachmentIds[0]];
        } else{
            imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",PA_NEW_NOTICE_URL,PANewNoticeImgPath,noticeModel.attachmentIds[0]]];
        }
        
        [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            /*
                [self.noticeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleLabel);
                    make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16);
                    make.right.equalTo(self.whiteView).with.offset(-10);
                    //make.height.mas_equalTo(image.size.height);
                    make.height.equalTo(@186);
                }];
            */
            /*
                [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleLabel);
                    make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16);
                    make.right.equalTo(self.whiteView).with.offset(-10);
                    //make.height.mas_equalTo(image.size.height);
                    make.height.equalTo(@186);
                }];
             */
             
            self.noticeImageView.image = image;

        }];
        
    } else {
        self.noticeImageView.hidden = YES;
        
        [self.noticeInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteView).with.offset(10);
            make.right.equalTo(self.whiteView).with.offset(-10);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16);
        }];
        /*
        [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16);
            make.right.equalTo(self.whiteView).with.offset(-10);
            make.height.equalTo(@1);
        }];
         */
    }
}

@end
