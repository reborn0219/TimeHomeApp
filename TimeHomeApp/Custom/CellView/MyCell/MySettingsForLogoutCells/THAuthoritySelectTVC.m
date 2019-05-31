//
//  THAuthoritySelectTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THAuthoritySelectTVC.h"
#import "THAuthoritySelectButton.h"

@interface THAuthoritySelectTVC ()

@property (nonatomic, strong) UILabel *detailsLabel;

@end

@implementation THAuthoritySelectTVC
{
    NSArray *rightSelectImages;
    NSArray *leftImages;
    NSArray *buttonTitles;
    NSInteger selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        rightSelectImages = @[@"维修评价_已选中",@"维修评价_未选中"];
        leftImages = @[@"我的_设置_清理缓存",@"设置_房产权限_房产授权_出租"];
        buttonTitles = @[@"共    享",@"出    租"];
        
        selected = 1;
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.font = DEFAULT_FONT(16);
    selectLabel.text = @"请选择授权方式";
    selectLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:selectLabel];
    selectLabel.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).topSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    for (int i = 0; i < 2; i ++) {
        
        THAuthoritySelectButton *button = [[THAuthoritySelectButton alloc] init];
        button.tag = i+1;
        [button addTarget:self action:@selector(buttonSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        CGFloat buttonWidth = (SCREEN_WIDTH-14-10-15*2)/2;
//        button.frame = CGRectMake(15+(buttonWidth+10)*i, WidthSpace(88), buttonWidth, WidthSpace(64));
        button.sd_layout.topSpaceToView(selectLabel,20).leftSpaceToView(self.contentView,15+(buttonWidth+10)*i).heightIs(WidthSpace(64)).widthIs(buttonWidth);
        button.leftImageView.image = [UIImage imageNamed:leftImages[i]];
        button.leftLabel.text = buttonTitles[i];
        button.rightImageView.image = [UIImage imageNamed:rightSelectImages[i]];
        if (i == 0) {
            button.layer.borderColor = kNewRedColor.CGColor;
            button.layer.borderWidth = 1;
        }else {
            button.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
            button.layer.borderWidth = 1;
        }
        
        
    }
    
    _detailsLabel = [[UILabel alloc]init];
    _detailsLabel.font = DEFAULT_FONT(14);
    _detailsLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_detailsLabel];
    
    THAuthoritySelectButton *leftButton = (THAuthoritySelectButton *)[self.contentView viewWithTag:1];
    _detailsLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(leftButton,WidthSpace(60)).rightSpaceToView(self.contentView,15).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_detailsLabel bottomMargin:WidthSpace(40)];
    
    
}
- (void)setModel:(LXModel *)model {
    
    _model = model;
    _detailsLabel.text = model.content;
    [self updateLayout];
    
}

- (void)buttonSelectClick:(THAuthoritySelectButton *)button {
    
    if (button.tag == selected) {
        return;
    }
    THAuthoritySelectButton *lastButton = (THAuthoritySelectButton *)[self.contentView viewWithTag:selected];
    lastButton.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    lastButton.layer.borderWidth = 1;
    lastButton.rightImageView.image = [UIImage imageNamed:rightSelectImages[1]];

    button.layer.borderColor = kNewRedColor.CGColor;
    button.layer.borderWidth = 1;
    button.rightImageView.image = [UIImage imageNamed:rightSelectImages[0]];

    selected = button.tag;
    
    if (self.selectedButtonCallBack) {
        self.selectedButtonCallBack(button.tag);
    }
}

@end
