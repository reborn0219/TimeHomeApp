//
//  L_NewMinePresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewMinePresenters.h"

#import "L_NewPointPresenters.h"

@implementation L_NewMinePresenters

#pragma mark - 3.9.9--我关注的用户（/userfollow/getfollow）
/**
 3.9.9--我关注的用户（/userfollow/getfollow）
 
 @param pagesize 分页数 可传递否则默认为20
 @param page 页码可不传递默认为1
 @param updataViewBlock
 */
+ (void)getMyFollowWithPagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/userfollow/getfollow",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"pagesize":[NSString stringWithFormat:@"%ld",(long)pagesize],@"page":[NSString stringWithFormat:@"%ld",(long)page],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0 || errcode == 99999)//返回操作成功
            {
                NSArray *array = [L_MyFollowersModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];

    
}
#pragma mark - 3.9.10--添加取消关注(/userfollow/addfollow)

/**
 3.9.10--添加取消关注(/userfollow/addfollow)
 
 @param userid 用户id
 @param type 0 新增 1 取消
 @param updataViewBlock
 */
+ (void)addFollowWithUserid:(NSString *)userid type:(NSInteger)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/userfollow/addfollow",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"type":[NSString stringWithFormat:@"%ld",(long)type],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

#pragma mark - 3.4.7--取消确认订单(/goodsorder/cancelorder)

/**
 3.4.7--取消确认订单(/goodsorder/cancelorder)
 
 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)cancelOrderWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodsorder/cancelorder",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.4.10--确认订单发货(/goodsorder/sendgoods)

/**
 3.4.10--确认订单发货(/goodsorder/sendgoods)
 
 @param postid 帖子id
 @param serialno 订单流水号
 @param updataViewBlock
 */
+ (void)sendGoodsWithPostid:(NSString *)postid serialno:(NSString *)serialno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodsorder/sendgoods",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"serialno":serialno,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.4.11--确认收货(/goodsorder/receiptgoods)

/**
 3.4.11--确认收货(/goodsorder/receiptgoods)
 
 @param postid 帖子id
 @param serialno 订单流水号
 @param updataViewBlock
 */
+ (void)receiptGoodsWithPostid:(NSString *)postid serialno:(NSString *)serialno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodsorder/receiptgoods",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"serialno":serialno,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.4.12--下架(/housepost/closehouse)

/**
 3.4.12--下架(/housepost/closehouse)
 
 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)offGoodsWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/housepost/closehouse",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                [newDict setDictionary:[UserDefaultsStorage getDataforKey:@"newDataArr"]];
                NSArray *newKeyArr = [newDict allKeys];
                for (int i = 0; i < newKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:newDict[newKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [newDict removeObjectForKey:newKeyArr[i]];
                    [newDict setObject:infoArr forKey:newKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:newDict forKey :@"newDataArr"];
                
                NSMutableDictionary *picDict = [NSMutableDictionary dictionary];
                [picDict setDictionary:[UserDefaultsStorage getDataforKey:@"picDataArr"]];
                NSArray *picKeyArr = [picDict allKeys];
                for (int i = 0; i < picKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:picDict[picKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [picDict removeObjectForKey:picKeyArr[i]];
                    [picDict setObject:infoArr forKey:picKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:picDict forKey :@"picDataArr"];
                
                NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                [cityDict setDictionary:[UserDefaultsStorage getDataforKey:@"cityDataArr"]];
                NSArray *cityKeyArr = [cityDict allKeys];
                for (int i = 0; i < cityKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:cityDict[cityKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [cityDict removeObjectForKey:cityKeyArr[i]];
                    [cityDict setObject:infoArr forKey:cityKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:cityDict forKey :@"cityDataArr"];
                
                [USER_DEFAULT setObject:@"yes" forKey:DELETE_LIST_VALUE_OK];
                [USER_DEFAULT synchronize];
                
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(dicJson,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

#pragma mark - 3.8.4--分页获得我发布的评论(/postcomment/getusercomment)

/**
 3.8.4--分页获得我发布的评论(/postcomment/getusercomment)
 
 @param page 页码
 @param pagesize 分页数 可传递否则默认为20
 @param updataViewBlock
 */
+ (void)getUserCommentWithPage:(NSInteger)page pagesize:(NSInteger)pagesize UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/postcomment/getusercomment",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":[NSString stringWithFormat:@"%ld",(long)page],@"pagesize":[NSString stringWithFormat:@"%ld",(long)pagesize],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_UserCommentModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.8.6--删除评论(/postcomment/deletecomment)

/**
 3.8.6--删除评论(/postcomment/deletecomment)
 
 @param postid 帖子id
 @param commentid 评论id
 @param updataViewBlock
 */
+ (void)deleteCommentWithPostid:(NSString *)postid commentid:(NSString *)commentid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/postcomment/deletecomment",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"commentid":commentid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.9.7--分页获得我的余额记录(/balance/getbalancelist)

/**
 3.9.7--分页获得我的余额记录(/balance/getbalancelist)
 
 @param page 页码可不传递默认为1
 @param pagesize 分页数 可传递否则默认为20
 @param updataViewBlock
 */
+ (void)getBalanceListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/balance/getbalancelist",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":[NSString stringWithFormat:@"%ld",(long)page],@"pagesize":[NSString stringWithFormat:@"%ld",(long)pagesize],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_BalanceListModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
 
    
}
#pragma mark - 3.9.8--余额提现(/balance/cashbalance)

/**
 3.9.8--余额提现(/balance/cashbalance)
 
 @param paytype 101 支付宝 102 微信
 @param paynumber 提现到账户
 @param money 金额
 @param updataViewBlock
 */
+ (void)cashBalanceListWithPaytype:(NSInteger)paytype UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/balance/cashbalance",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"paytype":[NSString stringWithFormat:@"%ld",(long)paytype],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"money":@"0"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
#pragma mark - 3.11.2--帮助与反馈(/help/gethelptype)

/**
 3.11.2--帮助与反馈(/help/gethelptype)
 
 @param updataViewBlock
 */
+ (void)getHelpTypeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/help/gethelptype",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_HelpModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];

    
}
#pragma mark -  3.4.4--获得我的购买(/goodspost/getbuypost)

/**
 3.4.4--获得我的购买(/goodspost/getbuypost)
 
 @param saletype 交易类型 0 正在交易 1 交易完成
 @param pagesize 分页数 可传递否则默认为20
 @param page 页码可不传递默认为1
 @param updataViewBlock
 */
/*
+ (void)getbuypostWithSaletype:(NSInteger)saletype pagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodspost/getbuypost",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"saletype":[NSString stringWithFormat:@"%ld",saletype],@"pagesize":[NSString stringWithFormat:@"%ld",pagesize],@"page":[NSString stringWithFormat:@"%ld",page]};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_BuypostModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
 */
#pragma mark -  3.4.3--获得我的出售(/goodspost/getsalepost)

/**
 3.4.3--获得我的出售(/goodspost/getsalepost)
 
 @param saletype 交易类型 0 正在交易 1 交易完成
 @param pagesize 分页数 可传递否则默认为20
 @param page 页码可不传递默认为1
 @param updataViewBlock
 */
/*
+ (void)getsalepostWithSaletype:(NSInteger)saletype pagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodspost/getsalepost",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"saletype":[NSString stringWithFormat:@"%ld",saletype],@"pagesize":[NSString stringWithFormat:@"%ld",pagesize],@"page":[NSString stringWithFormat:@"%ld",page]};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_SalepostModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}
 */
#pragma mark -  3.3.6--删除帖子(/post/deletepost)

/**
 3.3.6--删除帖子(/post/delpost)
 
 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)deletePostWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/post/delpost",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                
                NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                [newDict setDictionary:[UserDefaultsStorage getDataforKey:@"newDataArr"]];
                NSArray *newKeyArr = [newDict allKeys];
                for (int i = 0; i < newKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:newDict[newKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [newDict removeObjectForKey:newKeyArr[i]];
                    [newDict setObject:infoArr forKey:newKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:newDict forKey :@"newDataArr"];
                
                NSMutableDictionary *picDict = [NSMutableDictionary dictionary];
                [picDict setDictionary:[UserDefaultsStorage getDataforKey:@"picDataArr"]];
                NSArray *picKeyArr = [picDict allKeys];
                for (int i = 0; i < picKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:picDict[picKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [picDict removeObjectForKey:picKeyArr[i]];
                    [picDict setObject:infoArr forKey:picKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:picDict forKey :@"picDataArr"];
                
                NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                [cityDict setDictionary:[UserDefaultsStorage getDataforKey:@"cityDataArr"]];
                NSArray *cityKeyArr = [cityDict allKeys];
                for (int i = 0; i < cityKeyArr.count; i++) {
                    
                    NSMutableArray *infoArr = [NSMutableArray array];
                    [infoArr addObjectsFromArray:cityDict[cityKeyArr[i]]];
                    for (int j = 0; j < infoArr.count; j++) {
                        
                        NSDictionary *infoDict = infoArr[j];
                        if ([infoDict[@"id"] isEqualToString:postid]) {
                            
                            [infoArr removeObjectAtIndex:j];
                        }
                    }
                    [cityDict removeObjectForKey:cityKeyArr[i]];
                    [cityDict setObject:infoArr forKey:cityKeyArr[i]];
                }
                [UserDefaultsStorage saveCustomArray:cityDict forKey :@"cityDataArr"];
                
                [USER_DEFAULT setObject:@"yes" forKey:DELETE_LIST_VALUE_OK];
                [USER_DEFAULT synchronize];
                
                [L_NewPointPresenters updUserIntebyTypeWithType:21 content:@"删除帖子" costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                }];
                
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];

    
}
#pragma mark -  3.4.8--支付购买订单(/goodsorder/payorder)

/**
 3.4.8--支付购买订单(/goodsorder/payorder)
 
 @param postid 帖子id
 @param serialno 订单流水号
 @param paytype 支付类型0 余额 101 支付宝 102 微信；是否应该在支付订单界面？？？
 @param updataViewBlock
 */
+ (void)payOrderWithPostid:(NSString *)postid serialno:(NSString *)serialno paytype:(NSString *)paytype UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodsorder/payorder",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"serialno":serialno,@"paytype":paytype,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([dicJson objectForKey:@"map"],SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

/**
 3.4.9--支付成功购买订单(/goodsorder/payokorder)
 
 @param postid 帖子id
 @param serialno 订单流水号
 @param thirdpayno 第三方支付号
 @param updataViewBlock
 */
+ (void)payOkOrderWithPostid:(NSString *)postid serialno:(NSString *)serialno thirdpayno:(NSString *)thirdpayno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/goodsorder/payokorder",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"serialno":serialno,@"thirdpayno":thirdpayno,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}



/**
 判断用户是否关注微信公众号  关注以后方可提现
 
 @param unionid 用户绑定微信的unionid
 @param updataViewBlock 回调
 */
+ (void)whetherToFocusOn:(NSString *)unionid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/getwchatcheck",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"unionid":unionid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([dicJson objectForKey:@"map"],SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];

}

/**
 3.8.2	帖子点赞操作 /postpraise/addpraise
 
 @param type 0点赞 1取消点赞
 @param postid 帖子id
 */
+ (void)addPraiseType:(NSInteger)type withPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/postpraise/addpraise",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"postid":postid,@"type":[NSString stringWithFormat:@"%ld",(long)type],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

/**
 3.6.6	问答帖子点赞操作 /postpraise/addpraise
 
 @param type 0点赞 1取消点赞
 @param postid 帖子id
 */
+ (void)addQuestionPraiseType:(NSString *)type
                withcommentid:(NSString *)commentid
              UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/answerpost/praiseanswer",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"commentid":commentid,@"praisetype":[NSString stringWithFormat:@"%@",type],@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

/**
 3.6.3	问答帖子采纳 /answerpost/agreeanswer
 
 @param postid 帖子id
 @param commentid 回答id
 */
+ (void)agreeAnswerWithPostid:(NSString *)postID
                    commentid:(NSString *)commentid
              UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/answerpost/agreeanswer",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"commentid":commentid,@"postid":postID,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"成功返回数据==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"返回数据失败==%@",data);
        }
        
    }];
    
}

@end
