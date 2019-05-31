//
//  XMMImageTextMessageCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "XMMImageTextMessageCell.h"


#import "UIImageView+WebCache.h"
@interface XMMImageTextMessageCell  ()

/** 
   显示image的imageView
 */
@property (strong, nonatomic) UIImageView *messageImageView;
/**
   遮罩imageView
 */
@property (strong, nonatomic) UIImageView *messageMaskImageView;
/**
   文字
 */
@property (strong,nonatomic)UIView * backGroundView;

@property (strong, nonatomic) UILabel * textLb;
@property (strong, nonatomic) UILabel * moneyLb;
@property (strong, nonatomic) UILabel * unitLb;

@end
@implementation XMMImageTextMessageCell

#pragma mark - Override Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(XMImageTextMessageTapped:)]) {
        
        [self.messageDelegate XMImageTextMessageTapped:self.message];
    }
}

#pragma mark - Public Methods
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.backGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView);
        make.width.lessThanOrEqualTo(@(self.frame.size.width - 80));
    }];
    
    [self.textLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
            make.edges.equalTo(self.backGroundView).with.insets(UIEdgeInsetsMake(0,65, 0,20));
        }else
        {
            make.edges.equalTo(self.backGroundView).with.insets(UIEdgeInsetsMake(0,10, 0,65));
        }
        make.width.mas_greaterThanOrEqualTo(@80);
    }];
    
    [self.messageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.messageContentView.mas_top).offset(0);
        make.bottom.equalTo(self.messageContentView.mas_bottom).priorityHigh();
        make.height.equalTo(@60);
        make.width.equalTo(@60);
        
        if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
            make.left.equalTo(self.messageContentView.mas_left);
        }else{
            make.right.equalTo(self.messageContentView.mas_right);
        }
    }];
}

- (void)setup{
    [super setup];
    
    [self.messageContentView addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.messageImageView];
    [self.backGroundView addSubview:self.textLb];
}

- (void)setMessage:(Gam_Chat *)message{
    
    if ([XYString isBlankString:message.content]) {
        
        _textLb.text =@"";
    }else
    {
        _textLb.text = message.content;

    }
   
        [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:message.contentPicUrl] placeholderImage:PLACEHOLDER_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //imageMessage.imageSize = image.size;
        }];
        
        //            imageMessage.imageSize = self.messageImageView.image.size;
    
    self.messageMaskImageView.image = nil;
    
    if (message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
        self.messageMaskImageView.image = [[UIImage imageNamed:@"message_sender_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 50, 15, 30) resizingMode:UIImageResizingModeStretch];
    }else{
        self.messageMaskImageView.image = [[UIImage imageNamed:@"message_receiver_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 50, 15, 30) resizingMode:UIImageResizingModeStretch];
    }
    [super setMessage:message];
}

#pragma mark - Getters

- (UIImageView *)messageImageView{
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.contentScaleFactor = [[UIScreen mainScreen]scale];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
        _messageImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _messageImageView.clipsToBounds = YES;
        
    }
    return _messageImageView;
}
- (UIImageView *)messageMaskImageView{
    if (!_messageMaskImageView) {
        _messageMaskImageView = [[UIImageView alloc] init];
    }
    return _messageMaskImageView;
}
-(UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [[UILabel alloc]init];
        _textLb.lineBreakMode = NSLineBreakByWordWrapping;
        _textLb.numberOfLines = 0;
        _textLb.font = [UIFont systemFontOfSize:11.0f];
        _textLb.textColor = TEXT_COLOR;
        _textLb.preferredMaxLayoutWidth = self.frame.size.width - 60 - 40;
        _textLb.textAlignment = NSTextAlignmentLeft;
    }
    return _textLb;
}
-(UILabel *)moneyLb
{
    if (!_moneyLb) {
        _moneyLb = [[UILabel alloc]init];
        _moneyLb.lineBreakMode = NSLineBreakByWordWrapping;
        _moneyLb.numberOfLines = 0;
        _moneyLb.font = [UIFont systemFontOfSize:21.0f];
        _moneyLb.textColor = [UIColor redColor];
        _moneyLb.preferredMaxLayoutWidth = 50;
        _moneyLb.textAlignment = NSTextAlignmentLeft;
        _moneyLb.text = @"70";
    }
    return _moneyLb;

}
-(UILabel *)unitLb
{
    if (!_unitLb) {
        _unitLb = [[UILabel alloc]init];
        _unitLb.lineBreakMode = NSLineBreakByWordWrapping;
        _unitLb.numberOfLines = 0;
        _unitLb.font = [UIFont systemFontOfSize:12.0f];
        _unitLb.textColor = TEXT_COLOR;
        _unitLb.preferredMaxLayoutWidth = 50;
        _unitLb.textAlignment = NSTextAlignmentLeft;
        _unitLb.text = @"万";
    }
    return _unitLb;
    
}
-(UIView * )backGroundView
{
    if (!_backGroundView) {
        _backGroundView =[[UIView alloc]init];
        [_backGroundView setBackgroundColor:[UIColor whiteColor]];
    }
    return _backGroundView;
    
}
@end

