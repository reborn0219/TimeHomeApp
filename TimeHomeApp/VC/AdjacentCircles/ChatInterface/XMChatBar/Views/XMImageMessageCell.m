//
//  XMImageMessageCell.m
//  XMChatControllerExample
//
//  Created by shscce on 15/9/1.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMImageMessageCell.h"

#import "UIImageView+WebCache.h"
@interface XMImageMessageCell  ()

@property (strong, nonatomic) UIImageView *messageImageView /**< 显示image的imageView */;
@property (strong, nonatomic) UIImageView *messageMaskImageView /**< 遮罩imageView */;

@end

@implementation XMImageMessageCell

#pragma mark - Override Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches allObjects][0];
    CGPoint touchPoint = [touch locationInView:self.messageContentView];
    if (CGRectContainsPoint(self.messageMaskImageView.frame, touchPoint)) {
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(XMImageMessageTapped:withImgView:)]) {
            [self.messageDelegate XMImageMessageTapped:self.message withImgView:self.messageImageView];
        }
    }
}

#pragma mark - Public Methods
- (void)updateConstraints{
    [super updateConstraints];

    [self.messageMaskImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageContentView.mas_top);
        make.bottom.equalTo(self.messageContentView.mas_bottom).priorityHigh();
        make.height.mas_lessThanOrEqualTo(120);
        make.width.mas_lessThanOrEqualTo(120);
        if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
            make.right.equalTo(self.messageContentView.mas_right);
        }else{
            make.left.equalTo(self.messageContentView.mas_left);
        }
    }];
    
    [self.messageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageMaskImageView);
    }];

}

- (void)setup{
    [super setup];
    
    [self.messageContentView addSubview:self.messageImageView];
    [self.messageContentView addSubview:self.messageMaskImageView];
    
}

- (void)setMessage:(Gam_Chat *)message{
    
    
        if (message.ownerType.intValue == XMMessageOwnerTypeSelf) {
            
            self.messageImageView.image = [UIImage imageWithData:message.contentPicData];
            
        }else{
            
            [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:message.contentPicUrl] placeholderImage:PLACEHOLDER_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //imageMessage.imageSize = image.size;
            }];
            
//            imageMessage.imageSize = self.messageImageView.image.size;
        }
   
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

@end
