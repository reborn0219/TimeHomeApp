//
//  THMaskingView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMaskingView.h"
#import "MMPopupItem.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"

@implementation THMaskingView
{
    UIImageView *maskImageView;
}

+(instancetype)shareMaskingView
{
    static THMaskingView * shareMaskingView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareMaskingView = [[self alloc] init];
        
    });
    return shareMaskingView;
}
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    maskImageView.image = [UIImage imageNamed:imageName];
    [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self);
        
    }];
    
}
- (void)setImageRect:(CGRect)imageRect {
    _imageRect = imageRect;
}
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustomStyle2;

//        self.backgroundColor = UIColorFromRGB(0x6B6B6B);
//        self.backgroundColor = [UIColor colorWithWhite:<#(CGFloat)#> alpha:<#(CGFloat)#>];
        
        maskImageView = [[UIImageView alloc]init];
//        maskImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20);
        [self addSubview:maskImageView];
        
    }
    
    return self;
}

- (void)actionHide
{
    [self hide];
}


@end
