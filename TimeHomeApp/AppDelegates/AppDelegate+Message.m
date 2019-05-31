//
//  AppDelegate+Message.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/27.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Message.h"
#import "PushMsgModel.h"
#import "ChatPresenter.h"
#import "DataOperation.h"
#import "DateUitls.h"
#import "XMMessage.h"

@implementation AppDelegate (Message)

- (void)setPushNoticeWithLaunchOptions:(NSDictionary *)launchOptions{
    
    canGetNewMessage = YES;
    self.pushMsgType=@"0";
    self.pushMsgTime=@"";
    
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            
            UIApplication *app=[UIApplication sharedApplication];
            app.applicationIconBadgeNumber=0;
            
            id jsonString = [remoteNotification objectForKey:@"cjson"];
            NSDictionary *jsonDic;
            if ([jsonString isKindOfClass:[NSString class]]) {
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers              error:&err];
            } else{
                jsonDic = jsonString;
            }
            
            // 取cjson内容
            self.pushMsgType = [jsonDic objectForKey:@"type"];
            self.pushMsgTime = [jsonDic objectForKey:@"sendtime"];
            
            if (![self isBeyonbdDays]) {
                [self performSelector:@selector(pushNotice:) withObject:jsonDic afterDelay:1.0];
            }
            
        }
        
    }
    
}

- (void)pushNotice:(id)object {
    
    NSDictionary * cjson   = object;
    
    NSMutableDictionary *userInfo_dic = [NSMutableDictionary dictionaryWithDictionary:object];
    if ([cjson objectForKey:@"cjson"]) {
        [userInfo_dic setDictionary:cjson];
    }
    //[userInfo_dic setObject:[cjson objectForKey:@"type"] forKey:@"type"];
    [userInfo_dic setObject:@YES forKey:@"isclick"];
    
    if ([userInfo_dic[@"type"] integerValue] == 30101) {
        NSDictionary * dic = [userInfo_dic objectForKey:@"cjson"];
        [self synchronousChatData:dic :@""];
    }else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:userInfo_dic];
    }
    
}

- (NSString *)logDic:(NSDictionary *)dic{
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

#pragma mark - 消息分类处理统计计数
-(void)dealPushMsg:(NSDictionary *)dic :(NSString *)message :(NSString *)type {
    
    switch (type.integerValue) {
        case 10001://10001    个人消息：你的账户被多次举报请不要再违规
        case 10002://后台为用户重置密码：您的账号密码已重置为此手机号的后六位，请使用登录
        case 10003://请下载时代社区App地址[下载地址],开启您的时代。账号为手机号，密码手机号后六位
        case 10101://获得车位权限：您已获得车位[车位名称]的使用权限
        case 10102://失去车位权限：您已失去车位[车位名称]的使用权限
        case 10103://获得房产权限：您已获得房产[门牌号]的操作权限
        case 10104://失去房产权限：您已失去房产[门牌号]的操作权限
        case 10105://业主变更后台审核通过：您已通过XX小区的业主认证，去试试业主专享功能吧~
        case 10106://业主变更审核不通过：您未通过XX小区的业主认证，请填写准确信息后再次提交申请
        case 10113://车牌纠错推送
            
        case 10121://社区认证审核成功 您在时代社区1栋2单元2908室的房产认证成功，恭喜您成为该社区的认证业主。 map{“id”:”123dfdf3er13df”,”state”:1}
        case 10122://社区认证审核失败 您在时代社区1栋2单元2908室的房产认证审核失败，失败原因：您提供的业主信息有误，房产信息不对。 map{“id”:”123dfdf3er13df”,”state”:2}
            
        case 60001://大赛：审核通过：恭喜，您上传的摄影大赛作品[作品名称]已经审核通过，作品编号XX
        case 60002://大赛：未审核通过：非常遗憾，您上传的摄影大赛作品[作品名称]未审核通过
        case 20301://反馈回复
        case 30001://点赞
        case 30002://评论
        case 30003://回复评论
        case 30091:///帖子审核不通过
        case 30092:///帖子(删除)
        case 30093:///带红包帖子审核不通过推送
        case 30094:///用户禁言推送
        case 30999:///红包过期
        case 30292:///投票贴(投票时间结束)
        case 30311:///问答帖(收到奖励后推送)
        case 30312:///问答帖(采纳后推送)
        case 30392:///问答帖(奖励退回的推送)
        case 30492:///房产贴(房产贴线上时间到期)
        case 30501:///微信核销
        case 50001://车辆锁定状态出库：车辆[车牌号]的防盗装置发出警报，请立即处理
        case 50202://二轮车共享接口推送
        case 50203://二轮车定时锁车解锁修改接口推送
        case 50209://后台删除自行车
        case 90101:////新增定运营定制推送消息
        case 90201:////新增定运营定制推送消息
        case 90202:////新增定运营定制推送消息
        case 80001://赠送票券推送
        case 80002://即将到期兑换券推送
        {
            
            ///权限变更以后重新获取用户蓝牙摇一摇权限
            [self getBlueTouchData];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
            
        }
            break;
        case 50002://您的车辆已入库
        {
            [AppDelegate showToastMsg:@"您的车辆已入库" Duration:2.5f];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 50003://您的车辆已出库
        {
            [AppDelegate showToastMsg:@"您的车辆已出库" Duration:2.5f];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20001://社区公告：[公告]公告标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///community notification
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityNotification];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type = [dic objectForKey:@"type"];
            
            //            pushMsg.content = message;
            
            NSDictionary *diction = [message mj_JSONObject];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[diction objectForKey:@"content"]];
            }
            else
            {
                pushMsg.content=[diction objectForKey:@"content"];
            }
            
            num = [NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg = num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityNotification];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
        }
            break;
        case 20002://社区新闻：[新闻]新闻标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityNews];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityNews];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20003://社区活动：[活动]活动标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityActivitys];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityActivitys];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
            
            //-----------------------报修相关推送----------------------------------------------
            
        case 20101://物业已接收：XX物业已接收您的报修申请，正在分派维修人员 map:{“id”:”2323”}
            
        case 20102://维修处理中：维修人员[姓名]正在处理您的报修  map:{“id”:”2323”,“visitlinkman”:”张三”,”visitlinkphone”:”1232323232”}
            
        case 20103://物业驳回：您的报修因[驳回原因]被驳回，请完善信息后重新提交 map:{“id”:”2323”}
            
        case 20104://暂不维修：XX物业暂时无法处理你的报修申请 map:{“id”:”2323”}
            
        case 20105://已完成 待评价：您的报修已处理完成，给个评价吧  map:{“id”:”2323”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.RepairMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            
            NSDictionary * map=[dic objectForKey:@"map"];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[map objectForKey:@"id"]];
            }
            else
            {
                pushMsg.content=[map objectForKey:@"id"];
            }
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.RepairMsg];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20201://投诉回复：您的投诉XX物业已回复 map:{“id”:”2323”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.ComplainMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                pushMsg.content=@"";
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            
            NSDictionary * map=[dic objectForKey:@"map"];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[map objectForKey:@"id"]];
            }
            else
            {
                pushMsg.content=[map objectForKey:@"id"];
            }
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.ComplainMsg];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
            
        case 30101://收到个人聊天消息：“昵称：内容” 滑动查看，最多显示两行 map:{“maxid”:1221,”userid”:”dsfd”,”userpic”:”http://...”,”nickname”:””,”msgtype”:”1”}
        {
            [self synchronousChatData:dic :message];
        }
            break;
        case 50201://你的自行车疑似被盗
        {
            //自行车被盗报警
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 70001://摇摇通行电梯操作
        {
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel * )[UserDefaultsStorage getDataforKey:self.liftMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.liftMsg];
            
            ///摇摇通行电梯操作
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
        }
#pragma mark 车辆出库入库消息
            //给未注册手机号添加车位
        case 200309:{
            break;
        }
            //给未注册手机号关联车牌号
        case 200310:{
            break;
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - app消息计数
-(void)addMsgCount:(NSDictionary *)dic :(NSString *)message {
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.PersonalMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content=message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg=num;
    [UserDefaultsStorage saveData:pushMsg forKey:self.PersonalMsg];
}

#pragma mark - 同步聊天消息
-(void)synchronousChatData:(NSDictionary *)dic :(NSString *)message{
    [self addMsgCount:dic :message];
    ///计数统计 按识别码
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.ChatMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content = message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg = num;
    [UserDefaultsStorage saveData:pushMsg forKey:self.ChatMsg];
    
    NSNumber * maxid = [[NSUserDefaults standardUserDefaults]objectForKey:@"maxid"];
    
    ///根据用户ID 存储maxid
    if (![self.userData.userID isNotBlank]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:maxid forKey:self.userData.userID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (maxid == nil) {
        maxid = @(0);
    }
    NSLog(@"------------聊天maxid打印%@",maxid);
    if (canGetNewMessage) {
        canGetNewMessage = NO;
        [ChatPresenter getUserGamSync:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                canGetNewMessage = YES;
                
                if(resultCode == SucceedCode)
                {
                    NSArray * list = data;
                    NSLog(@"聊天消息获取---------%@",data);
                    
                    for (int i = 0;i<list.count ;i++) {
                        
                        NSDictionary * map  = [list objectAtIndex:i];
                        NSString * content = [map objectForKey:@"content"];
                        NSString * fileurl = [map objectForKey:@"fileurl"];
                        NSString * msgtype = [map objectForKey:@"msgtype"];
                        NSString * senduserid = [map objectForKey:@"senduserid"];
                        NSString * sendusername = [map objectForKey:@"sendusername"];
                        NSString * senduserpic = [map objectForKey:@"senduserpic"];
                        NSString * systime = [map objectForKey:@"systime"];
                        //                                NSString * type = [map objectForKey:@"type"];
                        NSDate * systime_date = [DateUitls DateFromString:systime DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                        
                        Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                        GC.chatID = senduserid;
                        GC.sendID = senduserid;
                        
                        GC.isFirstMsg = @(YES);
                        GC.systime = systime_date;
                        GC.headPicUrl = senduserpic;
                        
                        [[DataOperation sharedDataOperation] queryData:@"Gam_Chat" withHeadPicUrl:senduserpic andChatID:senduserid andnikeName:sendusername];
                        
                        GC.isRead = @(NO);
                        GC.ownerType = @(XMMessageOwnerTypeOther);
                        GC.sendName = sendusername;
                        if(self.userData!=nil&&self.userData.userID!=nil)
                        {
                            GC.userID=self.userData.userID;
                            GC.receiveID = self.userData.userID;
                            
                        }
                        GC.msgType = @(msgtype.integerValue);
                        ///0 文字 1 照片 2 语音
                        if (msgtype.integerValue==0) {
                            GC.cellIdentifier = @"XMTextMessageCell";
                            GC.content = content;
                        }
                        else if(msgtype.integerValue==1){
                            GC.cellIdentifier = @"XMImageMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = @"[图片]";
                            
                        }else if(msgtype.integerValue==2){
                            GC.cellIdentifier = @"XMVoiceMessageCell";
                            GC.voiceUrl = fileurl;
                            NSLog(@"录音文件－－－%@",fileurl);
                            GC.seconds = @(content.intValue);
                            GC.content = @"[语音]";
                            GC.voiceUnRead = @(YES);
                        }else if(msgtype.integerValue == 3){
                            GC.cellIdentifier = @"XMMImageTextMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = content;
                        }else{
                            GC.cellIdentifier = @"XMTextMessageCell";
                            GC.content = content;
                        }
                        [[DataOperation sharedDataOperation]save];
                    }
                    ///收到个人聊天消息
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
                }
            });
        } withMaxID:[NSString stringWithFormat:@"%@",maxid]];
    }
}

#pragma mark - 设置消息存储名称
/**
 设置消息存储名称
 */
-(void)setMsgSaveName{
    ////-----------------消息存储标记------------
    ///个人消息
    self.PersonalMsg = [NSString stringWithFormat:@"PersonalMsg%@",self.userData.userID];
    ///社区公告
    self.CommunityNotification = [NSString stringWithFormat:@"CommunityNotification%@%@",self.userData.userID,self.userData.communityid];
    ///社区新闻
    self.CommunityNews = [NSString stringWithFormat:@"CommunityNews%@%@",self.userData.communityid,self.userData.userID];
    ///社区活动
    self.CommunityActivitys = [NSString stringWithFormat:@"CommunityActivitys%@%@",self.userData.communityid,self.userData.userID];
    ///维修
    self.RepairMsg = [NSString stringWithFormat:@"RepairMsg%@%@",self.userData.communityid,self.userData.userID];
    ///投诉
    self.ComplainMsg = [NSString stringWithFormat:@"ComplainMsg%@%@",self.userData.communityid,self.userData.userID];
    
    ///聊天
    self.BBSMsg=[NSString stringWithFormat:@"BBSMsg%@",self.userData.userID];
    self.ChatMsg=[NSString stringWithFormat:@"ChatMsg%@",self.userData.userID];
    
    ///电梯
    self.liftMsg=[NSString stringWithFormat:@"liftMsg%@",self.userData.userID];
}

@end

