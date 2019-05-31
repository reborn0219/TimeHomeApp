//
//  THHomeGridViewListItemView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THHomeGridViewListItemView.h"

@implementation THHomeGridViewListItemView
{
    /**
     *  删除按钮
     */
    UIButton *cancelButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_itemButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_itemButton];
    [_itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _headLabel = [[UILabel alloc]init];
    _headLabel.text = @"头像";
    _headLabel.hidden = YES;
    _headLabel.textColor = [UIColor whiteColor];
    _headLabel.textAlignment = NSTextAlignmentCenter;
    _headLabel.font = DEFAULT_BOLDFONT(14);
    _headLabel.backgroundColor = RGBAFrom0X(0xd21e1d,0.7);
    [_itemButton addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(_itemButton);
        make.height.equalTo(@WidthSpace(36));
        
    }];
    
    cancelButton = [[UIButton alloc] init];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"个人设置_头像_上传照片_删除照片"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_itemButton addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_itemButton).offset(-WidthSpace(8));
        make.top.equalTo(_itemButton).offset(WidthSpace(8));
        make.width.height.equalTo(@(WidthSpace(46)));
    }];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressed:)];
    [self addGestureRecognizer:longPressed];
}
#pragma mark - actions

- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    if (self.itemLongPressedOperationBlock) {
        self.itemLongPressedOperationBlock(longPressed);
    }
}

- (void)buttonClicked
{
    if (self.buttonClickedOperationBlock) {
        self.buttonClickedOperationBlock(self);
    }
}

- (void)cancelButtonClicked
{
    if (self.cancelButtonClickedOperationBlock) {
        self.cancelButtonClickedOperationBlock(self);
    }
}
#pragma mark - properties
- (void)setPhotoWall:(UserPhotoWall *)photoWall {
    
    _photoWall = photoWall;
    if ([XYString isBlankString:photoWall.fileurl]) {
        [_itemButton setBackgroundImage:photoWall.image forState:UIControlStateNormal];

    }else {
        [_itemButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoWall.fileurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];

    }
    
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
