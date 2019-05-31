//
//  PAH5Url.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/16.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAH5Url : NSObject


///- - urllink
/*登录接口返回在map字段的URL字段*/
@property (copy,nonatomic) NSString *mallindexurl;//商城
@property (copy,nonatomic) NSString *mallnearurl;//商城附近
@property (copy,nonatomic) NSString *mallsearchurl;//商城搜索

@property (copy,nonatomic) NSString *firedescurl;//消防
@property (copy,nonatomic) NSString *partyurl;//党建
@property (copy,nonatomic) NSString *homeintrourl;//智能家居
@property (copy,nonatomic) NSString *policeurl;//警务信息

@property (copy,nonatomic) NSString *safehomeurl;//平安社区
@property (copy,nonatomic) NSString *urlnewslist;//新闻地址

/*登录接口返回在最外层的URL字段*/
@property (copy,nonatomic) NSString *url_gamcommindex;//社区帖子主页
@property (copy,nonatomic) NSString *url_postparkingarea;//车位贴发布
@property (copy,nonatomic) NSString *url_posthouse;//房产贴发布
@property (copy,nonatomic) NSString *url_gamuserindex;//个人主页
@property (copy,nonatomic) NSString *url_postaddasn;//问答贴发布
@property (copy,nonatomic) NSString *url_postadd;//普通帖发布
@property (copy,nonatomic) NSString *url_postaddgoods;//商品帖发布
@property (copy,nonatomic) NSString *url_postaddvoto;//投票贴发布

#warning 此字段无返回
@property (copy,nonatomic) NSString *url_postsearchhouse;//车位，房产列表地址

@end
