//
//  PAH5UrlManager.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/16.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAH5UrlManager.h"

@implementation PAH5UrlManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAH5UrlManager)

-(PAH5Url*)h5urls{
    
    PAH5Url *urls = [[PAH5Url alloc]init];
    
    return urls;
}

-(void)saveUrls:(PAH5Url*)urlModel{
    AppDelegate *appdelegate = GetAppDelegates;
    
    
    appdelegate.userData.mallindexurl = urlModel.mallindexurl;
    
    appdelegate.userData.mallsearchurl = urlModel.mallsearchurl;
    
    appdelegate.userData.mallnearurl = urlModel.mallnearurl;
    
    appdelegate.userData.partyurl = urlModel.partyurl;
    
    appdelegate.userData.homeintrourl = urlModel.homeintrourl;
    
    appdelegate.userData.policeurl = urlModel.policeurl;
    
    appdelegate.userData.firedescurl = urlModel.firedescurl;
    
    appdelegate.userData.safehomeurl = urlModel.safehomeurl;
    
    appdelegate.userData.urlnewslist = urlModel.urlnewslist;
    
    appdelegate.userData.url_postadd = urlModel.url_postadd;
    
    appdelegate.userData.url_posthouse = urlModel.url_posthouse;
    
    appdelegate.userData.url_postaddasn = urlModel.url_postaddasn;
    
    appdelegate.userData.url_postaddvoto = urlModel.url_postaddvoto;
    
    appdelegate.userData.url_gamcommindex = urlModel.url_gamcommindex;
    
    appdelegate.userData.url_gamuserindex = urlModel.url_gamuserindex;
    
    appdelegate.userData.url_postaddgoods = urlModel.url_postaddgoods;
    
    appdelegate.userData.url_postparkingarea = urlModel.url_postparkingarea;
    
    appdelegate.userData.url_postsearchhouse = urlModel.url_postsearchhouse;
    
    [appdelegate saveContext];
}

-(void)saveUrls:(PAH5Url*)urlModel isInMap:(BOOL)isInMap{
    
    AppDelegate *appdelegate = GetAppDelegates;
    
    
        appdelegate.userData.mallindexurl = urlModel.mallindexurl;
        
        appdelegate.userData.mallsearchurl = urlModel.mallsearchurl;
        
        appdelegate.userData.mallnearurl = urlModel.mallnearurl;
        
        appdelegate.userData.partyurl = urlModel.partyurl;
        
        appdelegate.userData.homeintrourl = urlModel.homeintrourl;
        
        appdelegate.userData.policeurl = urlModel.policeurl;
        
        appdelegate.userData.firedescurl = urlModel.firedescurl;
        
        appdelegate.userData.safehomeurl = urlModel.safehomeurl;
        
        appdelegate.userData.urlnewslist = urlModel.urlnewslist;
    
        appdelegate.userData.url_postadd = urlModel.url_postadd;
        
        appdelegate.userData.url_posthouse = urlModel.url_posthouse;
        
        appdelegate.userData.url_postaddasn = urlModel.url_postaddasn;
        
        appdelegate.userData.url_postaddvoto = urlModel.url_postaddvoto;
        
        appdelegate.userData.url_gamcommindex = urlModel.url_gamcommindex;
        
        appdelegate.userData.url_gamuserindex = urlModel.url_gamuserindex;
        
        appdelegate.userData.url_postaddgoods = urlModel.url_postaddgoods;
        
        appdelegate.userData.url_postparkingarea = urlModel.url_postparkingarea;
        
        appdelegate.userData.url_postsearchhouse = urlModel.url_postsearchhouse;
    
    [appdelegate saveContext];
    
}

@end
