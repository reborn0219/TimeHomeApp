//
//  PASuggestDetailView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestDetailView.h"
#import "PASuggestPhotoView.h"
@interface PASuggestDetailView ()
@property (nonatomic, strong)UILabel *communityLabel;
@property (nonatomic, strong)UILabel *communityNameLabel;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UILabel *numberInfoLabel;
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UILabel *stateInfoLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *timeInfoLabel;
@property (nonatomic, strong)UITextView * inputView;
@property (nonatomic, strong)PASuggestPhotoView * photoView;

@end

@implementation PASuggestDetailView

- (instancetype)init{
    if (self = [super init]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    self.backgroundColor = UIColorHex(0xF5F5F5);
    UIView * whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = UIColor.whiteColor;
    [self addSubview:whiteView];
    
    [whiteView addSubview:self.numberLabel];
    [whiteView addSubview:self.numberInfoLabel];
    UIView * line1 = [self lineView];
    [whiteView addSubview:line1];
    
    [whiteView addSubview:self.communityLabel];
    [whiteView addSubview:self.communityNameLabel];
    
    UIView * line2 = [self lineView];
    [whiteView addSubview:line2];
    [whiteView addSubview:self.stateLabel];
    [whiteView addSubview:self.stateInfoLabel];
    
    UIView * line3 = [self lineView];
    [whiteView addSubview:line3];

    [whiteView addSubview:self.timeLabel];
    [whiteView addSubview:self.timeInfoLabel];
    
    [self addSubview:self.inputView];
    [self addSubview:self.photoView];
    
    CGFloat space = 10;
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(0);
        make.height.equalTo(@204);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).with.offset(13);
        make.top.equalTo(whiteView).with.offset(17);
    }];
    
    [self.numberInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberLabel);
        make.left.equalTo(self.numberLabel.mas_right).with.offset(space);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(whiteView);
        make.height.equalTo(@1);
        make.top.equalTo(self.numberLabel.mas_bottom).with.offset(16);
    }];
    
    [self.communityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(line1.mas_bottom).with.offset(17);
    }];
    [self.communityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.communityLabel);
        make.left.equalTo(self.communityLabel.mas_right).with.offset(space);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(line1);
        make.top.equalTo(self.communityLabel.mas_bottom).with.offset(16);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(line2.mas_bottom).with.offset(17);
    }];
    [self.stateInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLabel);
        make.left.equalTo(self.stateLabel.mas_right).with.offset(space);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(line1);
        make.top.equalTo(self.stateLabel.mas_bottom).with.offset(16);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateLabel);
        make.top.equalTo(line3.mas_bottom).with.offset(17);
    }];
    [self.timeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.left.equalTo(self.timeLabel.mas_right).with.offset(space);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@108);
        make.top.equalTo(whiteView.mas_bottom).with.offset(33);
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@110);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(10);
    }];
    self.inputView.textContainerInset = UIEdgeInsetsMake(16, 9, 16, 13);

    [self.photoView dismissTag];
}
#pragma mark -Lazyload

- (UILabel *)communityLabel{
    if (!_communityLabel) {
        _communityLabel = [self createLabelWithText:@"投诉社区:"];
    }
    return _communityLabel;
}

- (UILabel *)communityNameLabel{
    if (!_communityNameLabel) {
        _communityNameLabel = [self createLabelWithText:@""];
    }
    return _communityNameLabel;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [self createLabelWithText:@"投诉单号:"];
    }
    return _numberLabel;
}
- (UILabel *)numberInfoLabel{
    if (!_numberInfoLabel) {
        _numberInfoLabel = [self createLabelWithText:@""];
    }
    return _numberInfoLabel;
}
- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [self createLabelWithText:@"投诉状态:"];
    }
    return _stateLabel;
}
- (UILabel *)stateInfoLabel{
    if (!_stateInfoLabel) {
        _stateInfoLabel = [self createLabelWithText:@""];
    }
    return _stateInfoLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithText:@"投诉时间:"];
    }
    return _timeLabel;
}
- (UILabel *)timeInfoLabel{
    if (!_timeInfoLabel) {
        _timeInfoLabel = [self createLabelWithText:@""];
    }
    return _timeInfoLabel;
}

- (UITextView *)inputView{
    if (!_inputView) {
        _inputView = [[UITextView alloc]init];
        _inputView.font = [UIFont systemFontOfSize:14];
        _inputView.textColor = UIColorHex(0x4A4A4A);
        _inputView.editable = NO;
    }
    return _inputView;
}
- (PASuggestPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [[PASuggestPhotoView alloc]init];
    }
    return _photoView;
}

- (UILabel *)createLabelWithText:(NSString *)text{
    UILabel * label = [[UILabel alloc]init];
    label.textColor =UIColorHex(0x4A4A4A);
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    return label;
}
- (UIView *)lineView{
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorHex(0xEFEFEF);
    return line;
}

- (void)setDetailModel:(PASuggestDetailModel *)detailModel{
    if (_detailModel!=detailModel) {
        _detailModel =detailModel;
    }
    self.numberInfoLabel.text = detailModel.workOrderCode;
    self.communityNameLabel.text = detailModel.communityName;
    self.stateInfoLabel.text = detailModel.complaintState;
    self.timeInfoLabel.text = detailModel.createTime;
    self.inputView.text = detailModel.complaintDetails;
    if (detailModel.attachmentIds.count == 0) {
        self.photoView.hidden = YES;
    } else{
        self.photoView.hidden = NO;
        [self.photoView showPhotos:detailModel.attachmentIds];
    }
}
@end
