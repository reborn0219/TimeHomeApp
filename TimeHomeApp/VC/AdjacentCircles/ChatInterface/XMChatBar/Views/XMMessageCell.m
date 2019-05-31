//
//  XMMessageCell.m
//  XMChatControllerExample
//
//  Created by shscce on 15/9/1.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMMessageCell.h"
#import "XMSystemMessage.h"
#import "XMTextMessage.h"
#import "XMImageMessage.h"
#import "XMLocationMessage.h"
#import "XMVoiceMessage.h"
#import "Gam_Chat.h"
#import "DateTimeUtils.h"

//!!! test
#import "UIImageView+WebCache.h"
@interface XMMessageCell    ()

@property (strong, nonatomic) UIMenuController *menuController /**< 长按弹出选择框 */;
@property (strong, nonatomic) UILabel * systimeLb;

@end

@implementation XMMessageCell


+ (NSString *)cellIndetifyForMessage:(NSString *)message{
    return message;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.messageNickNameLabel];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.systimeLb];
    self.systimeShow = @(YES);
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGes.numberOfTouchesRequired = 1;
    longPressGes.minimumPressDuration = 1.0f;
    [self.contentView addGestureRecognizer:longPressGes];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Override Methods

- (void)updateConstraints{
    [super updateConstraints];
    
    self.avatarImageView.hidden = NO;

//    if (self.message.flag.integerValue == XMMessageChatSingle) {
//        self.messageNickNameLabel.hidden = YES;
//        [self.messageNickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.avatarImageView.mas_top).with.offset(-8);
//            make.width.equalTo(@0);
//            make.height.equalTo(@0);
//            if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
//                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-8);
//            }else{
//                make.left.equalTo(self.avatarImageView.mas_right).with.offset(8);
//            }
//        }];
//    }else if (self.message.flag.integerValue == XMMessageChatGroup){
//        self.messageNickNameLabel.hidden = NO;
//        [self.messageNickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.avatarImageView.mas_top).with.offset(-4);
//            make.width.lessThanOrEqualTo(@200);
//            make.height.equalTo(@10);
//            if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
//                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-8);
//            }else{
//                make.left.equalTo(self.avatarImageView.mas_right).with.offset(8);
//            }
//        }];
//    }
    
    
    if (self.systimeShow.boolValue){

        [self.systimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.height.equalTo(@kSystimeLB_H);
            make.width.greaterThanOrEqualTo(@10);
        }];
        
    }else
    {
        [self.systimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.height.equalTo(@0);
            make.width.greaterThanOrEqualTo(@10);

        }];
    }
    
    [self.messageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.systimeLb.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
        if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
            make.right.equalTo(self.avatarImageView.mas_left).with.offset(-8);
        }else{
            make.left.equalTo(self.avatarImageView.mas_right).with.offset(8);
        }
    }];
    
    if (self.message.ownerType.integerValue == XMMessageOwnerTypeOther) {
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(self.systimeLb.mas_bottom).with.offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8).priorityMedium();
            make.width.equalTo(@kAvatarSize);
            make.height.equalTo(@kAvatarSize);
        }];
 
    }else if (self.message.ownerType.integerValue == XMMessageOwnerTypeSelf){
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.top.equalTo(self.systimeLb.mas_bottom).with.offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8).priorityMedium();
            make.width.equalTo(@kAvatarSize);
            make.height.equalTo(@kAvatarSize);
        }];
    }else{
        self.avatarImageView.hidden = YES;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches allObjects][0];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentView.frame, touchPoint)) {
        self.messageBackgroundImageView.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.messageBackgroundImageView.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.messageBackgroundImageView.highlighted = NO;
    UITouch *touch = [touches allObjects][0];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    if (CGRectContainsPoint(self.avatarImageView.frame, touchPoint) || CGRectContainsPoint(self.messageNickNameLabel.frame, touchPoint)) {
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(XMMessageAvatarTapped:)]) {
            [self.messageDelegate XMMessageAvatarTapped:self.message];
        }
    }else if (CGRectContainsPoint(self.messageContentView.frame, touchPoint)){
        
    }else{
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(XMMessageBankTapped:)]) {
            [self.messageDelegate XMMessageBankTapped:self.message];
        }
    }
}


#pragma mark - UIMenuController 需要的方法
//以下两个方法必须有
/*
 *  让UIView成为第一responser
 */
- (BOOL)canBecomeFirstResponder{
    return YES;
}

/*
 *  根据action,判断UIMenuController是否显示对应aciton的title
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(doCellCopy) || action == @selector(doCellShare)) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes{
    if (longPressGes.state == UIGestureRecognizerStateBegan) {

        //首先自己成为第一responser
        [self becomeFirstResponder];
        //!!!此处使用self.superview.superview 获得到cell所在的tableView,不是很严谨,有哪位知道更加好的方法请告知
        [self.menuController setTargetRect:self.frame inView:self.superview.superview];
        [self.menuController setMenuVisible:YES animated:YES];
        
    }
}
- (void)doCellCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.message.content;
}

- (void)doCellShare{
    if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(XMMessageLongTapAction:withIndex:)]) {
        [self.messageDelegate XMMessageLongTapAction:self.message withIndex:_indexPath];
    }
}

#pragma mark - Setters

- (void)setMessage:(Gam_Chat *)message{
    
    _message = message;
    self.systimeLb.text = [DateTimeUtils StringFromDateTime:message.systime];
    if (message.ownerType.integerValue == XMMessageOwnerTypeSelf) {
        self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,20,23) resizingMode:UIImageResizingModeStretch];
        self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_sender_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,20,23) resizingMode:UIImageResizingModeStretch];
    }else if (message.ownerType.integerValue  == XMMessageOwnerTypeOther){
        [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,23,20,20) resizingMode:UIImageResizingModeStretch]];
        self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_receiver_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,23,20,20) resizingMode:UIImageResizingModeStretch];
    }
//    self.messageNickNameLabel.text = message.senderNickName;
//    //[self.avatarImageView setImageWithUrlString:message.senderAvatarThumb];
////    NSLog(@"==-=-=-=-=-=-%@",message.senderAvatarThumb);
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.senderAvatarThumb] placeholderImage:nil];
    
    [self updateConstraints];
}

#pragma mark - Getters

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = BLACKGROUND_COLOR;
        _avatarImageView.layer.cornerRadius = kAvatarCornerRadius;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}


- (UIImageView *)messageBackgroundImageView{
    if (!_messageBackgroundImageView) {
        _messageBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageBackgroundImageView;
}

- (UILabel *)messageNickNameLabel{
    if (!_messageNickNameLabel) {
        _messageNickNameLabel = [[UILabel alloc] init];
        _messageNickNameLabel.font = [UIFont systemFontOfSize:10.0f];
        _messageNickNameLabel.textColor = [UIColor darkGrayColor];
        _messageNickNameLabel.text = @"测试昵称";
    }
    return _messageNickNameLabel;
}

- (UIView *)messageContentView{
    if (!_messageContentView) {
        _messageContentView = [[UIView alloc] init];
        [_messageContentView setBackgroundColor:BLACKGROUND_COLOR];

    }
    return _messageContentView;
}

- (UIMenuController *)menuController{
    if (!_menuController) {
        _menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(doCellCopy)];
        UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(doCellShare)];
        if (self.message.msgType.integerValue) {
            [_menuController setMenuItems:@[shareItem]];

        }else
        {
            [_menuController setMenuItems:@[copyItem,shareItem]];

        }
//        [_menuController setArrowDirection:UIMenuControllerArrowDown];
    }
    return _menuController;
}
-(UILabel *)systimeLb
{
    if (!_systimeLb) {
        _systimeLb = [[UILabel alloc]init];
        _systimeLb.font = [UIFont systemFontOfSize:11.0f];
        _systimeLb.backgroundColor = UIColorFromRGB(0xCCCCCC);
        _systimeLb.layer.masksToBounds = YES;
        _systimeLb.layer.cornerRadius = 2;
        _systimeLb.textColor = [UIColor whiteColor];
        _systimeLb.textAlignment = NSTextAlignmentCenter;
    }
    return _systimeLb;
}
@end
