//
//  NewsPresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///社区新闻
#import "BasePresenters.h"

@interface NewsPresenter : BasePresenters

///获得用户关注频道  newszaker/getuserchannellist

+(void)getZakerUserChanneList:(UpDateViewsBlock)block;

///获得用户关注频道新闻  newszaker/getchannelinfo
+(void)getZakerChannelinfo:(NSString *)channel andPage:(NSString *)page withBlock:(UpDateViewsBlock)block;

///保存频道 newszaker/savechannels
+(void)getZakerSaveChannels:(NSString *)channels withBlock:(UpDateViewsBlock)block;


///频道切换以后统计IP  newszaker /visitchannel
+(void)getZakerVisitChannel:(NSString *)ipAdress andChannel:(NSString *)channel withBlock:(UpDateViewsBlock)block;

-(void)getZakerNewsForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得社区新闻类型（/comnewstype/getcomnewstype）
 */
-(void)getComNewsTypeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
获得社区首页新闻数据（/comnews/gettopcomnews）
 type	0 本社区 1 全部
 page	分页页码
 */
-(void)getTopComNewsForType:(NSString *) type page:(NSString *)page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得社区新闻列表（/comnews/getappcomnews）
 type	0 本社区 1 全部
 page	分页页码
 */
-(void)getAppComNewsForType:(NSString *) type page:(NSString *)page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
