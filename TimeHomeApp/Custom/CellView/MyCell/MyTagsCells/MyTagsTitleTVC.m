//
//  MyTagsTitleTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyTagsTitleTVC.h"

@interface MyTagsTitleTVC ()

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel *myTitleLabel;

@end

@implementation MyTagsTitleTVC


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    _leftImageView.image = leftImage;
    
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    _myTitleLabel.text = titleString;
}

- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthSpace(40));
        make.bottom.equalTo(self.contentView).offset(-WidthSpace(24));
        make.width.equalTo(@(WidthSpace(40)));
        make.height.equalTo(@(WidthSpace(40)));
    }];
    
    _myTitleLabel = [[UILabel alloc]init];
    _myTitleLabel.font = DEFAULT_BOLDFONT(15);
    _myTitleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_myTitleLabel];
    [_myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(WidthSpace(24));
        make.centerY.equalTo(_leftImageView.mas_centerY);
    }];
    
}

@end
