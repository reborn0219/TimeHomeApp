//
//  XMTextMessageCell.m
//  XMChatControllerExample
//
//  Created by shscce on 15/9/1.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMTextMessageCell.h"

#import "XMFaceManager.h"

@interface XMTextMessageCell  ()

@property (strong, nonatomic) UILabel *messageTextLabel;

@property (assign, nonatomic, readonly) CGFloat textMaxWidth;

@end

@implementation XMTextMessageCell


#pragma mark - Public Methods


- (void)updateConstraints{
    [super updateConstraints];
        
    [self.messageBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView);
        make.width.lessThanOrEqualTo(@(self.textMaxWidth));
    }];
    
    [self.messageTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageBackgroundImageView).with.insets(UIEdgeInsetsMake(8, 12, 8, 12));
    }];
}

- (void)setup{
    [super setup];
    [self.messageContentView addSubview:self.messageBackgroundImageView];
    [self.messageContentView addSubview:self.messageTextLabel];
}


#pragma mark - Setters

- (void)setMessage:(Gam_Chat *)message{
    
    NSMutableAttributedString *attrS = [XMFaceManager emotionStrWithString:message.content];
    [attrS addAttributes:[self textStyle:message] range:NSMakeRange(0, attrS.length)];
    
    self.messageTextLabel.attributedText = attrS;
    NSLog(@"text－－－－%@",self.messageTextLabel.text);
    [super setMessage:message];

}

#pragma mark - Getters


- (UILabel *)messageTextLabel {
    if (!_messageTextLabel) {
        _messageTextLabel = [[UILabel alloc] init];
        _messageTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageTextLabel.numberOfLines = 0;
        _messageTextLabel.textColor = [UIColor whiteColor];
        _messageTextLabel.preferredMaxLayoutWidth = self.textMaxWidth;
        _messageTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageTextLabel;
}

- (NSDictionary *)textStyle:(Gam_Chat *)message {
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    if (message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
        style.alignment = NSTextAlignmentLeft;
        _messageTextLabel.textColor = [UIColor whiteColor];

    }else if (message.ownerType.integerValue == XMMessageOwnerTypeOther)
    {
        style.alignment = NSTextAlignmentLeft;
        _messageTextLabel.textColor = TITLE_TEXT_COLOR;

    }
    style.paragraphSpacing = 0.25 * font.lineHeight;
    style.hyphenationFactor = 1.0;
    return @{NSFontAttributeName: font,
             NSParagraphStyleAttributeName: style};
}

/**
 *  text最大的宽度 - 60 (头像宽度以及左右间距)  -40(是否发送成功标志)
 *
 *  @return
 */
- (CGFloat)textMaxWidth{
    return self.frame.size.width - 60 - 40;
}
@end
