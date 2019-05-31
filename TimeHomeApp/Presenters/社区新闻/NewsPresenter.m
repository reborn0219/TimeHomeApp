//
//  NewsPresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NewsPresenter.h"

@implementation NewsPresenter

///获得用户关注频道  newszaker/getuserchannellist

+(void)getZakerUserChanneList:(UpDateViewsBlock)block
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/newszaker/getuserchannellist2",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            if(errcode==0)//返回操作成功
            {
                block(dicJson,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}

///获得用户关注频道新闻  newszaker/getchannelinfo
+(void)getZakerChannelinfo:(NSString *)channel andPage:(NSString *)page withBlock:(UpDateViewsBlock)block
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/newszaker/getchannelinfo2",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"channel":channel,@"page":page};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            if(errcode==0)//返回操作成功
            {
                block([dicJson objectForKey:@"list"],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}

///保存频道 newszaker/savechannels
+(void)getZakerSaveChannels:(NSString *)channels withBlock:(UpDateViewsBlock)block
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/newszaker/savechannels",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"channels":channels};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            if(errcode==0)//返回操作成功
            {
                block(dicJson,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}


///频道切换以后统计IP  newszaker/visitchannel
+(void)getZakerVisitChannel:(NSString *)ipAdress andChannel:(NSString *)channel withBlock:(UpDateViewsBlock)block
{
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/newszaker/visitchannel",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"ip":ipAdress,@"channel":channel};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            if(errcode==0)//返回操作成功
            {
                block(dicJson,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}



/**
 获得ZAKER社会新闻（/newszaker/gettop3news）
 */
-(void)getZakerNewsForupDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    
    
    NSString * url=[NSString stringWithFormat:@"%@/newszaker/getnewstop9",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray * array=[dicJson objectForKey:@"list"];
                updataViewBlock(array,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}

/**
 获得社区新闻类型（/comnewstype/getcomnewstype）
 */
-(void)getComNewsTypeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/comnewstype/getcomnewstype",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”类型名称”
             ,”systime”:”2015-01-01 12:23”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
/**
 获得社区首页新闻数据（/comnews/gettopcomnews）
 type	0 本社区 1 全部
 page	分页页码
 */
-(void)getTopComNewsForType:(NSString *) type page:(NSString *)page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/comnews/gettopcomnews",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"type":type,@"page":page};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”:”12122“
             ,”communityname”:”社区名称”
             ,”title”:”新闻标题”
             ,”content”:”内容…”
             ,”typeid”:”12”
             ,”typename”:”热门活动”
             ,”systime”:”2015-01-01 23:23”
             ,”piclist”:[{
             “id”:”12”
             ,”fileurl”:”http://...”
             }]
             ,”gotourl”:”http://...”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array=[dicJson objectForKey:@"list"];
                updataViewBlock(array,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}

/**
 获得社区新闻列表（/comnews/getappcomnews）
 type	0 本社区 1 全部
 page	分页页码
 */
-(void)getAppComNewsForType:(NSString *) type page:(NSString *)page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/comnews/getappcomnews",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"type":type,@"page":page};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”:”12122“
             ,”communityname”:”社区名称”
             ,”title”:”新闻标题”
             ,”content”:”内容…”
             ,”typeid”:“12”
             ,”typename”:”热门活动”
             ,”systime”:”2015-01-01 23:23”
             ,”piclist”:[{
             “id”:”12“
             ,”fileurl”:”http://...”
             }]
             ,”gotourl”:”http://...”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray * array=[dicJson objectForKey:@"list"];
                updataViewBlock(array,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(dicJson,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];

    
}
@end
