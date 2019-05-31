//
//  L_HouseDetailForthTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailForthTVC.h"

@interface L_HouseDetailForthTVC ()

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
/**
 跳转点赞列表按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *praiseListButton;

@end

@implementation L_HouseDetailForthTVC

- (void)setModel:(L_HouseDetailModel *)model {
    
    _model = model;
    
    if (![XYString isBlankString:model.praisecount]) {
        _praiseCount.text = [NSString stringWithFormat:@"%@",model.praisecount];
    }else {
        _praiseCount.text = 0;
    }
    
    if (model.ispraise.integerValue == 0) {
        _praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
    }else {
        _praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
    }
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view == _praiseButton || view == _praiseListButton) {
                continue;
            }else {
                [view removeFromSuperview];
            }
        }
    }
    
    [_praiseListButton addTarget:self action:@selector(allHeadersButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];

    /**
     最新点赞用户
     userid	用户id
     userpicurl	用户图片url
     nickname	用户昵称
     */
    //    @property (nonatomic, strong) NSArray *praiselist;
    
    NSInteger count = (SCREEN_WIDTH - 16 - 70 - 8 ) / (36 + 5);
    
    if (model.praiselist.count < count) {
        count = model.praiselist.count;
    }
    
    if (count > 0) {
        
        for (int i = 0; i < count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(8+8 + (36 + 5)*i, 7, 36, 36);
            button.layer.cornerRadius = 18;
            button.clipsToBounds = YES;
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.praiselist[i] objectForKey:@"userpicurl"]] forState:UIControlStateNormal placeholderImage:kHeaderPlaceHolder];
            
            button.tag = 100 + i;
            [button addTarget:self action:@selector(allHeadersButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            [self.contentView bringSubviewToFront:button];
        }
        
    }

    
}
- (void)allHeadersButtonDidTouch:(UIButton *)sender {
    
    if (sender.tag == 10000) {
        
        if (self.headerButtonDidBlock) {
            self.headerButtonDidBlock(nil);
        }
        
    }else {
        
        NSString *userid = [_model.praiselist[sender.tag-100] objectForKey:@"userid"];
        
        if ([XYString isBlankString:userid]) {
            return;
        }
        
        if (self.headerButtonDidBlock) {
            self.headerButtonDidBlock(userid);
        }
        
    }
    
}

- (IBAction)praiseButtonDidTouch:(UIButton *)sender {
    NSLog(@"点赞");
    if (self.praiseButtonDidBlock) {
        self.praiseButtonDidBlock();
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _praiseCount.text = @"0";
    _praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
