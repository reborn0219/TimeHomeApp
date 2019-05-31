//
//  XMVoiceMessageCell.h
//  XMChatControllerExample
//
//  Created by shscce on 15/9/1.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMMessageCell.h"

@interface XMVoiceMessageCell : XMMessageCell<XMVoiceMessageStatus>

@property (strong, nonatomic) UIImageView *voiceReadStateImageView /**< 显示voice是否已读 */;

@end
