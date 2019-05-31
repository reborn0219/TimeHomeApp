//
//  XMMessage.m
//  XMChatControllerExample
//
//  Created by shscce on 15/9/1.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMMessage.h"

#import "XMSystemMessage.h"
#import "XMTextMessage.h"
#import "XMImageMessage.h"
#import "XMVoiceMessage.h"
#import "XMLocationMessage.h"

@implementation XMMessage

- (instancetype)init{
    if ([super init]) {
        self.messageType = XMMessageTypeUnknow;
    }
    return self;
}



+ (XMTextMessage *)textMessage:(NSDictionary *)messageInfo{
    XMTextMessage *textMessage = [[XMTextMessage alloc] init];
    textMessage.messageOwner = [messageInfo[@"messageOwner"] integerValue];
    textMessage.messageText = messageInfo[@"messageText"];
    textMessage.messageTime = [messageInfo[@"messageTime"] doubleValue];
    textMessage.senderAvatarThumb = messageInfo[@"senderAvatarThumb"];
    textMessage.senderNickName = messageInfo[@"senderNickName"];
    textMessage.senderID = messageInfo[@"userID"];

    textMessage.senderTime = messageInfo[@"senderTime"];

    return textMessage;
}


+ (XMImageMessage *)imageMessage:(NSDictionary *)messageInfo{
    XMImageMessage *imageMessage = [[XMImageMessage alloc] init];
    imageMessage.send_type = messageInfo[@"send_type"];
    imageMessage.messageOwner = [messageInfo[@"messageOwner"] integerValue];
    imageMessage.messageText = messageInfo[@"messageText"];
    imageMessage.messageTime = [messageInfo[@"messageTime"]doubleValue];
    imageMessage.senderAvatarThumb = messageInfo[@"senderAvatarThumb"];
    imageMessage.senderNickName = messageInfo[@"senderNickName"];
    imageMessage.senderTime = messageInfo[@"senderTime"];
    imageMessage.senderID = messageInfo[@"userID"];

    if (imageMessage.send_type.intValue == 1) {
        imageMessage.imageUrlString = messageInfo[@"imageUrlString"];
        imageMessage.image = messageInfo[@"image"];
        
    }else
    {
        imageMessage.imageUrlString = messageInfo[@"imageUrlString"];

    }
//    if ([image isKindOfClass:[UIImage class]]) {
//        imageMessage.image = image;
//    }else if ([image isKindOfClass:[NSString class]]){
//        if ([image hasPrefix:@"http://"]) {
//            imageMessage.imageUrlString = messageInfo[@"imageUrlString"];
//        }else{
//            imageMessage.image = [UIImage imageNamed:image];
//        }
//    }
    return imageMessage;
}

+ (XMSystemMessage *)systemMessage:(NSDictionary *)messageInfo{
    XMSystemMessage *systemMessage = [[XMSystemMessage alloc] init];

   // systemMessage.messageTime = [messageInfo[@"senderTime"] doubleValue];
    NSString *messageText = messageInfo[@"senderTime"];
    systemMessage.messageText = messageText;

//    if (messageText) {
//        systemMessage.messageText = messageText;
//    }else{
//        systemMessage.messageText = [[NSDate dateWithTimeIntervalSince1970:systemMessage.messageTime] description];
//    }
    return systemMessage;
}

+ (XMLocationMessage *)locationMessage:(NSDictionary *)messageInfo{
    XMLocationMessage *locationMesssage = [[XMLocationMessage alloc] init];
    locationMesssage.messageOwner = [messageInfo[@"messageOwner"] integerValue];;
    locationMesssage.messageTime = [messageInfo[@"messageTime"] doubleValue];
    locationMesssage.address = messageInfo[@"address"];
    locationMesssage.senderAvatarThumb = messageInfo[@"senderAvatarThumb"];
    locationMesssage.senderNickName = messageInfo[@"senderNickName"];
    locationMesssage.senderID = messageInfo[@"userID"];

    return locationMesssage;
}

+ (XMVoiceMessage *)voiceMessage:(NSDictionary *)messageInfo{
    XMVoiceMessage *voiceMessage = [[XMVoiceMessage alloc] init];
    voiceMessage.voiceSeconds = [messageInfo[@"voiceSeconds"] integerValue];
    voiceMessage.messageOwner = [messageInfo[@"messageOwner"] integerValue];;
    voiceMessage.messageTime = [messageInfo[@"messageTime"] doubleValue];
    voiceMessage.senderAvatarThumb = messageInfo[@"senderAvatarThumb"];
    voiceMessage.senderNickName = messageInfo[@"senderNickName"];
    voiceMessage.senderTime = messageInfo[@"senderTime"];
    voiceMessage.senderID = messageInfo[@"userID"];

    
    id voice = messageInfo[@"voiceData"];
    if ([voice isKindOfClass:[NSData class]]) {
        voiceMessage.voiceData = voice;
    }else{
        voiceMessage.voiceUrlString = voice;
    }
    return voiceMessage;
}

@end
