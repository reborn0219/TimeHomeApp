//
//  YYCarCheckTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYCarCheckTVC.h"

@implementation YYCarCheckTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        
    }];

    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = DEFAULT_FONT(14);
//    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_leftImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
    }];
    
}


@end
