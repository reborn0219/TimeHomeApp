//
//  PANoticeManager.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANoticeManager.h"
#import "PANoticeService.h"
#import "PAParkingViewController.h"
#import "MessageAlert.h"
#import "YYPlaySound.h"
#import "PushMsgModel.h"
#import "CommunityManagerPresenters.h"
#import "ChatPresenter.h"
#import "DataOperation.h"
#import "DateUitls.h"
#import "XMMessage.h"


@implementation PANoticeManager
{
}
+(void)saveDeviceInfo {
    
    [PANoticeService saveDeviceInfoSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 解绑设备信息
 */
+(void)unBindDeviceInfo{
    
    [PANoticeService unbindDeviceSuccess:^(PABaseRequestService *service) {
        
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}


/**
 处理后台状态下接受到的推送消息
 
 @param notification 推送消息body中cjson内容
 */
+(void)manageNotification:(NSDictionary *)notification{
    
    AppDelegate * delegate = GetAppDelegates;
    // 后端推送的为字符 转为dictionary;
    NSString * notificationString = [notification objectForKey:@"cjson"];
    
    NSData *jsonData = [notificationString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    NSLog(@"执行推送处理");
    NSInteger typeCode = [[dic objectForKey:@"type"] integerValue];
    switch (typeCode) {
#pragma mark 车辆出库入库消息
        case 200401:{
            //新推送公告
            NSString * noticeCode = dic [@"extra"][@"id"];
            NSString * communityId = dic [@"extra"][@"communityid"];
            if (delegate.userData.token && delegate.userData.token.length>0 && [delegate.userData.communityid isEqualToString:communityId]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_NewNotice" object:noticeCode];
            }
                        break;
        }
        case 200402:{
            //新投诉建议
            NSString * suggestCode = dic [@"extra"][@"id"];
            NSString * communityId = dic [@"extra"][@"communityid"];
            if ([delegate.userData.communityid isEqualToString:communityId]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_NewSuggest" object:suggestCode];
            } else{
                return;
            }
            break;
        }
            //正常入库
        case 200101:
            //车位过期不允许入库
        case 200102:
            //车位过期入库不收费
        case 200103:
            //车位过期入库，将产生停车费用
        case 200104:
            //车位已满入库，将产生停车费用
        case 200105:
        case 200201://出库
            
        case 200202://物业锁车出库
            
            //业主锁车出库
        case 200203:
            //添加车位
        case 200301:
            //删除车位
        case 200302:
            
            //修改车位手机号
        case 200303:
            //个人车位承租方
        case 200304:
            //个人车位承租方到期
        case 200305:
            //个人车位承租方即将到期
        case 200306:
            //移除出租车位
        case 200307:
            //车位即将到期
        case 200308:{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Parking" object:nil];
        }
    }
}

/**
 处理极光透传消息
 
 @param message 透传消息body
 */
+(void)manageJPushReceiveMessage:(NSDictionary *)message{
    
    // message.content
    NSString * messageContent = message[@"content"];
    
    NSInteger typeCode = [[message objectForKey:@"type"] integerValue];
    AppDelegate * appdel = GetAppDelegates;
    NSString * PersonalMsg = [NSString stringWithFormat:@"PersonalMsg%@",appdel.userData.userID];
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:PersonalMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type = @(typeCode);
    pushMsg.content = @"";
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg=num;
    //[UserDefaultsStorage saveData:pushMsg forKey:PersonalMsg];
    
    switch (typeCode) {
            //正常入库
        case 200101:
            //车位过期不允许入库
        case 200102:
            //车位过期入库不收费
        case 200103:
            //车位过期入库，将产生停车费用
        case 200104:
            //车位已满入库，将产生停车费用
        case 200105:
        case 200201://出库
            //添加车位
        case 200301:
            //删除车位
        case 200302:
            
            //修改车位手机号
        case 200303:
            //个人车位承租方
        case 200304:
            //个人车位承租方到期
        case 200305:
            //个人车位承租方即将到期
        case 200306:
            //移除出租车位
        case 200307:
            //车位即将到期
        case 200308:{
            
            NSString * showMessage = message[@"content"];
            [AppDelegate showToastMsg:showMessage Duration:2.5f];
        }
            break;
            case 200202://物业锁车出库
            case 200203://业主锁车出库
        {
            [PANoticeManager alarmSoundAlert];
        }
            break;
    }
    
}

#pragma mark - 报警声音
+(void)alarmSoundAlert
{
    
    YYPlaySound *playSound = [[YYPlaySound alloc]init];
    [playSound playSoundWithResourceName:@"fangdaobaojing" ofType:@"wav" isRepeat:NO];
    AppDelegate * appdel = GetAppDelegates;
    UIViewController * currentVC = [appdel getCurrentViewController];
    [currentVC becomeFirstResponder];
    MessageAlert * msgAlert = [[MessageAlert alloc]init];
    msgAlert.isHiddLeftBtn = YES;
    [msgAlert showInVC:currentVC withTitle:@"车辆防盗装置发出警报，请立即处理！" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
    msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [playSound stopAudioWithSystemSoundID:playSound.thesoundID];
            
        });
    };
}

#pragma mark - app消息计数

/*
+(void)addMsgCount:(PushMsgModel* )pushMessageModel message:(NSString *)message {
    
    AppDelegate * delegate = GetAppDelegates;
    NSNumber * num;
    PushMsgModel * pushMsg = pushMessageModel;
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg=num;
    [UserDefaultsStorage saveData:pushMsg forKey:delegate.PersonalMsg];
}
 */

///获取蓝牙设备权限数据
+(void)getBlueTouchData
{
    [CommunityManagerPresenters getUserBluetoothUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                
                NSArray *array=(NSArray *)data;
                if([data isKindOfClass:[NSArray class]])
                {
                    if(array==nil||array.count==0)
                    {
                        return ;
                    }
                    [UserDefaultsStorage saveData:array forKey:@"UserUnitKeyArray"];
                }
            }
            else
            {
                //                 [self showToastMsg:data Duration:5.0];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *errmessage = data[@"errmsg"];
                    
                    [UserDefaultsStorage saveData:@[] forKey:@"UserUnitKeyArray"];
                    [UserDefaultsStorage saveData:errmessage forKey:@"Blue_errmessage"];
                }
            }
            
        });
        
    }];
    
}

#pragma mark - 同步聊天消息
-(void)synchronousChatData:(NSDictionary *)dic message:(NSString *)message
{
    
    //[self addMsgCount:dic :message];
    ///计数统计 按识别码
    NSNumber * num;
    AppDelegate * delegate = GetAppDelegates;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.ChatMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content = message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg = num;
    [UserDefaultsStorage saveData:pushMsg forKey:delegate.ChatMsg];
    
    NSNumber * maxid = [[NSUserDefaults standardUserDefaults]objectForKey:@"maxid"];
    
    ///根据用户ID 存储maxid
    if (![delegate.userData.userID isNotBlank]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:maxid forKey:delegate.userData.userID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (maxid == nil) {
        maxid = @(0);
    }
    NSLog(@"------------聊天maxid打印%@",maxid);
    
    if (self.canGetNewMessage) {
        _canGetNewMessage = NO;
        [ChatPresenter getUserGamSync:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _canGetNewMessage = YES;
                
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
                        if(delegate.userData!=nil&&delegate.userData.userID!=nil)
                        {
                            GC.userID=delegate.userData.userID;
                            GC.receiveID = delegate.userData.userID;
                            
                        }
                        GC.msgType = @(msgtype.integerValue);
                        ///0 文字 1 照片 2 语音
                        if (msgtype.integerValue==0) {
                            GC.cellIdentifier = @"XMTextMessageCell";
                            GC.content = content;
                            
                        }
                        else if(msgtype.integerValue==1)
                        {
                            GC.cellIdentifier = @"XMImageMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = @"[图片]";
                            
                        }else if(msgtype.integerValue==2)
                        {
                            GC.cellIdentifier = @"XMVoiceMessageCell";
                            GC.voiceUrl = fileurl;
                            NSLog(@"录音文件－－－%@",fileurl);
                            GC.seconds = @(content.intValue);
                            GC.content = @"[语音]";
                            GC.voiceUnRead = @(YES);
                        }else if(msgtype.integerValue == 3)
                        {
                            
                            GC.cellIdentifier = @"XMMImageTextMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = content;
                        }else
                        {
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

//-(void)dealPushMsg:(NSDictionary *)dic :(NSString *)message :(NSString *)type {


/**
 旧平安社区推送消息整合

 @param dic content字典
 @param message 展示内容
 @param type 推送类型
 */
+(void)managerOldReceiveMessage:(NSDictionary *)dic message:(NSString *)message type:(NSString *)type{
    AppDelegate * delegate = GetAppDelegates;
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
            [self addMsgCount:dic message:message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];

        }
            break;
        case 50002://您的车辆已入库
        {
            [AppDelegate showToastMsg:@"您的车辆已入库" Duration:2.5f];
            [self addMsgCount:dic message:message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 50003://您的车辆已出库
        {
            
            [AppDelegate showToastMsg:@"您的车辆已出库" Duration:2.5f];
            [self addMsgCount:dic message:message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
            
        }
            break;
            
            
        case 20001://社区公告：[公告]公告标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///community notification
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.CommunityNotification];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type = [dic objectForKey:@"type"];
            
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
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.CommunityNotification];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
        }
            break;
        case 20002://社区新闻：[新闻]新闻标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.CommunityNews];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.CommunityNews];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20003://社区活动：[活动]活动标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.CommunityActivitys];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.CommunityActivitys];
            
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
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.RepairMsg];
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
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.RepairMsg];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20201://投诉回复：您的投诉XX物业已回复 map:{“id”:”2323”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.ComplainMsg];
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
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.ComplainMsg];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
            
        case 30101://收到个人聊天消息：“昵称：内容” 滑动查看，最多显示两行 map:{“maxid”:1221,”userid”:”dsfd”,”userpic”:”http://...”,”nickname”:””,”msgtype”:”1”}
        {
            [[[PANoticeManager alloc]init]synchronousChatData:dic message:message];
        }
            break;
        case 50201://你的自行车疑似被盗
        {
            //自行车被盗报警
            [self addMsgCount:dic message:message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 70001://摇摇通行电梯操作
        {
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel * )[UserDefaultsStorage getDataforKey:delegate.liftMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:delegate.liftMsg];
            
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

+(void)addMsgCount:(NSDictionary *)dic message:(NSString *)message {
    
    AppDelegate * delegate = GetAppDelegates;
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:delegate.PersonalMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content=message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg=num;
    [UserDefaultsStorage saveData:pushMsg forKey:delegate.PersonalMsg];
}

/**
 处理后台状态下接收到的旧版本推送消息
 
 @param oldNotification 推送消息body
 */
+ (void)managerOldNotification:(NSDictionary *)userInfo{
 
    NSMutableDictionary * userInfo_dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([userInfo objectForKey:@"cjson"]) {
        
        [userInfo_dic setDictionary:userInfo];
        
    }
    [userInfo_dic setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
    [userInfo_dic setObject:@YES forKey:@"isclick"];
    
    NSDictionary * dic = [userInfo objectForKey:@"cjson"];
    NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    
    if (type.integerValue == 30101) {
        
        //[[PANoticeManager alloc]init] synchronousChatData:dic :@""];
        [[[PANoticeManager alloc]init] synchronousChatData:dic message:@""];

        
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:userInfo_dic];
    }
}



@end
