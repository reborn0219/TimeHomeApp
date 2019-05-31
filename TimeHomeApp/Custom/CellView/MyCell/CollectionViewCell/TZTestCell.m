//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"

@interface TZTestCell ()

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"个人设置_头像_上传照片_删除照片"] forState:UIControlStateNormal];
        _cancelButton.clipsToBounds = YES;
        [self.contentView addSubview:_cancelButton];
        _cancelButton.sd_layout.widthIs(WidthSpace(46)).heightIs(WidthSpace(46)).topSpaceToView(self.contentView,WidthSpace(6)).rightSpaceToView(self.contentView,WidthSpace(6));
        _cancelButton.sd_cornerRadiusFromWidthRatio = @(0.5);
        [_cancelButton addTarget:self action:@selector(cancelImageClick) forControlEvents:UIControlEventTouchUpInside];
        
        _headImageLabel = [[UILabel alloc]init];
        _headImageLabel.textColor = TITLE_TEXT_COLOR;
        _headImageLabel.textAlignment = NSTextAlignmentCenter;
        _headImageLabel.font = DEFAULT_BOLDFONT(13);
        _headImageLabel.text = @"头像";
        _headImageLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.contentView addSubview:_headImageLabel];

        
    }
    return self;
}

- (void)cancelImageClick {
    if (self.cancelImageCallBack) {
        self.cancelImageCallBack();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    
    [_headImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(WidthSpace(36)));
    }];
}

@end
