//
//  ChatViewController.h
//  XMChatControllerExample
//
//  Created by shscce on 15/9/3.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "XMMessage.h"

@interface ChatViewController :THBaseViewController

@property (copy, nonatomic) NSString *chatterName /**< 正在聊天的用户昵称 */;
@property (copy, nonatomic) NSString *chatterThumb /**< 正在聊天的用户头像 */;
@property (copy, nonatomic) NSString *ReceiveID;
- (instancetype)initWithChatType:(XMMessageChatType)messageChatType;
@property (nonatomic,assign)BOOL isGoods;
@property (nonatomic,strong)NSDictionary * goodsDic;
@property (nonatomic, strong) NSString *goodPicURL;/** 商品图片 */
@property (nonatomic, strong) NSString *goodTitle;/** 商品标题 */

@end
