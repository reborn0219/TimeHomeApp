;//
//  PostPresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PostPresenter.h"
#import "RecommendTopicModel.h"
#import "TopicPostModel.h"
#import "TopicDetailModel.h"
#import "TopicPostModel.h"

@implementation PostPresenter

///获取邻圈广告位advertise/getgamadvertise
+(void)getGamadvertise :(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/advertise/getgamadvertise",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {
                block(list,SucceedCode);
                
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
///获取全部圈子
+(void)getAllTopic:(NSString*)name withPage:(NSString*)page withBlock:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/getalltopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"name":name,@"page":page};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///获取我关注的圈子
+(void)getFollowTopic:(NSString*)name withPage:(NSString*)page withBlock:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/getfollowtopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"name":name,@"page":page};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///获得热门话题（/topic/gethottopic）
+(void)getHotTopic:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/gethottopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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

///获得推荐的话题（/topic/getrecommendtopic）
+(void)getRecommendTopic:(NSString *)page :(UpDateViewsBlock)block
{
    
    NSString * url=[NSString stringWithFormat:@"%@/topic/getrecommendtopic",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            NSLog(@"list=====%@",list);
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///得到最近浏览的话题（/topic/getfllowtopic）
+(void)getFllowTopic:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/getrecenttopic",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///我创建的话题（/topic/getusertopic）
+(void)getUserTopic:(UpDateViewsBlock)block withPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/getusertopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"userid":appDelegate.userData.userID};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [UserTopicModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
                
            }
            else//返回操作失败
            {
//                NSDictionary * dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得单个话题帖子信息（/topic/gettopicinfo）
+(void)getTopicInfo:(UpDateViewsBlock)block withTopicID:(NSString *)topicid
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/gettopicinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"topicid":topicid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSDictionary * map = [dicJson objectForKey:@"map"];
            if(errcode==0)//返回操作成功
            {
                block([RecommendTopicModel mj_objectWithKeyValues:map],SucceedCode);
                
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
///新增话题（/topic/addtopic）
+(void)addTopic:(UpDateViewsBlock)block withTitle:(NSString *)title andRemarks:(NSString *)remarks andPicid:(NSString*)picid
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/addtopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"title":title,@"remarks":remarks,@"picid":picid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block(dicJson,SucceedCode);
                
            }else if(errcode == 90003) //返回操作失败
            {
                block(dicJson,CustomCode);
            }else
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
///删除话题（/topic/removetopic）
+(void)removeTopic:(UpDateViewsBlock)block withTopicID:(NSString *)topicid
{
    NSString * url=[NSString stringWithFormat:@"%@/topic/removetopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"topicid":topicid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
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
///获得帖子详情（/topicposts/gettopicpostsinfo）
+(void)getTopicPostsInfo:(UpDateViewsBlock)block withTopicID:(NSString *)postsid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/gettopicpostsinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postsid":postsid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                
               
                block([TopicPostModel mj_objectWithKeyValues:[dicJson objectForKey:@"map"]] ,SucceedCode);
                
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
///分页获取已关注话题内帖子（/topicposts/getfollowtopicposts）
+(void)getFollowTopicPosts:(NSString * )page :(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/getfollowtopicposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {
                
                block([TopicPostModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///分页获得话题帖子（/topicposts/getapptopicposts）
+(void)getAppTopicPosts:(UpDateViewsBlock)block withPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/getapptopicposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            if(errcode==0)//返回操作成功
            {

                block([TopicPostModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///分页话题内的帖子（/topicposts/gettopicposts）
+(void)getTopicPosts:(UpDateViewsBlock)block withPage:(NSString *)page andTopicID:(NSString*)topicid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/gettopicposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"topicid":topicid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
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
///话题内的我发布的帖子（/topicposts/gettopicuserposts）
+(void)getTopicUserPosts:(UpDateViewsBlock)block withPage:(NSString *)page withUserID:(NSString*)userid

{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/gettopicuserposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSString * user_id = userid;
    if ([user_id isEqualToString:@""]) {
        user_id = appDelegate.userData.userID;
        
    }
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"userid":user_id};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            
            if(errcode==0)//返回操作成功
            {
                
                block([TopicPostModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
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
///删除话题内我发布的帖子（/topicposts/removetopicposts）
+(void)removeTopicPosts:(UpDateViewsBlock)block withTopicID:(NSString *)postsid withReason:(NSString *)reason
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/removetopicposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postsid":postsid,@"reason":reason};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block(@"删除成功！",SucceedCode);
                
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
///添加帖子点赞（/topicpostspraise/addtopicpraise）
+(void)addTopicPraise:(UpDateViewsBlock)block withTopicID:(NSString *)postsid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicpostspraise/addtopicpraise",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postsid":postsid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block(@"点赞成功",SucceedCode);
                
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
///删除帖子点赞（/topicpostspraise/removetopicpraise）
+(void)removeTopicPraise:(UpDateViewsBlock)block withTopicID:(NSString *)postsid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicpostspraise/removetopicpraise",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postsid":postsid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block(@"取消点赞",SucceedCode);
                
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
///添加帖子评论（/topicpostscomment/addtopiccomment）
+(void)addTopicComment:(UpDateViewsBlock)block withPostID:(NSString *)postsid andContent:(NSString*)content andCommentID:(NSString *)commentid andUserID:(NSString *)userid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicpostscomment/addtopiccomment",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postsid":postsid,@"content":content,@"commentid":commentid,@"userid":userid};
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
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
///删除帖子回复（/topicpostscomment/removetopiccomment）
+(void)removeTopicComment:(UpDateViewsBlock)block withCommentID:(NSString *)commentid
{
    NSString * url=[NSString stringWithFormat:@"%@/topicpostscomment/removetopiccomment",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"commentid":commentid};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
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
///获得邻圈未读消息个数(/postsmsg/getnoreadmsgcount)
+(void)getMsgCount:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/postsmsg/getnoreadmsgcount",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block([NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"noreadcount"]],SucceedCode);
                
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
///获得邻圈未读消息(/postsmsg/getmsg)(0未读 1已读)
+(void)getMsg:(UpDateViewsBlock)block withType:(NSString *)type
{
    NSString * url=[NSString stringWithFormat:@"%@/postsmsg/getnoreadmsg",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"type":type};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSMutableArray *array = [UserMsgModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
                
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

///添加话题关注followtopic/addfollowtopic
+(void)addFollowTopic:(NSString *)topicid WithCallBack:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/followtopic/addfollowtopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"topicid":topicid};
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
            NSLog(@"%@",dicJson);
            block(@"关注成功！",SucceedCode);
            
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///删除话题关注/followtopic/removefollowtopic
+(void)removeFollowTopic:(NSString *)topicid WithCallBack:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/followtopic/removefollowtopic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"topicid":topicid};
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
            NSLog(@"%@",dicJson);
            block(@"取消关注成功！",SucceedCode);
            
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///添加话题帖子（/topicposts/addtopicposts）
+(void)addTopicPosts:(NSString *)topicid withPicIDs:(NSString *)picids andContent:(NSString *)content andCallBack:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/topicposts/addtopicposts",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"topicid":topicid,@"picids":picids,@"content":content};
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"%@",dicJson);
            
            if (errcode==0) {
                block(dicJson,SucceedCode);

            }else
            {
                block(errmsg,FailureCode);

            }
            
            
        }else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
        
    }];

}
#pragma mark - 2016.12.01 修改2.2版本帖子举报/post/reportpost
///举报话题帖子 （/postsreport/addpostsreport）
+(void)addPostsReport:(NSString *)postsid withType:(NSString *)type andSource:(NSString*)source andCallBack:(UpDateViewsBlock)block
{
    
    NSString * url=[NSString stringWithFormat:@"%@/post/reportpost",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postsid,@"type":type,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSLog(@"%@",dicJson);
            block(dicJson,SucceedCode);
        }else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
        
    }];
}
@end
