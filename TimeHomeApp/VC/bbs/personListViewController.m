//
//  personListViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "personListViewController.h"

#import "BBSMainPresenters.h"

#import "WebViewVC.h"

#import "CommunityListViewController.h"

#import "L_NewMinePresenters.h"

#import "ChatViewController.h"

#import "MyFollowVC.h"

#import "MyFansVC.h"

#import "L_BBSVisitorsListViewController.h"

#import "personListViewController.h"
#import "L_HouseDetailsViewController.h"
#import "L_NormalDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "HouseOrCarViewController.h"

//------------普通帖cell--------------
#import "BBSNormalTableViewCell.h"
#import "BBSNormal2TableViewCell.h"
#import "BBSNormal1TableViewCell.h"
#import "BBSNormal0TableViewCell.h"
//------------广告帖cell--------------
#import "BBSAdvertTableViewCell.h"
#import "BBSAdvert2TableViewCell.h"
#import "BBSAdvert1TableViewCell.h"
#import "BBSAdvert0TableViewCell.h"
//------------投票贴cell--------------
#import "BBSVotePICTableViewCell.h"
#import "BBSVotePIC2TableViewCell.h"
#import "BBSVoteTextTableViewCell.h"
#import "BBSVoteText2TableViewCell.h"
//------------问答帖cell--------------
#import "BBSQuestionPICTableViewCell.h"
#import "BBSQuestionPIC2TableViewCell.h"
#import "BBSQuestionPIC1TableViewCell.h"
#import "BBSQuestionNoPICTableViewCell.h"
//------------商品帖cell--------------
#import "BBSCommodityTableViewCell.h"
#import "BBSCommodity2TableViewCell.h"
#import "BBSCommodity1TableViewCell.h"
//------------房产帖cell--------------
#import "BBSHouseTableViewCell.h"
#import "BBSHouse2TableViewCell.h"
#import "BBSHouse1TableViewCell.h"
#import "BBSHouse0TableViewCell.h"

#import "L_ShareActivityTVC.h"

@interface personListViewController () <UITableViewDelegate, UITableViewDataSource,SDPhotoBrowserDelegate>
{
    
    AppDelegate *appDlgt;
    
    NSInteger listType;
    
    NSString *userID_;
    
    UIView *headerView;
    
    NSDictionary *topDict;//顶部参与数，帖子数字典
    
    NSMutableArray *dataArray;//帖子列表数据源
    
    UIButton *followButton;//关注按钮
    
    NSInteger type_;//关注类型
    
    NSInteger pageNo;//分页记录
    
    UIView *holdView;//展示没有数据视图
    
    UITableView *tableView_;
    
    UILabel *postcount;//帖子数
    
    UILabel *postjoincount;//参与人数
    
    UIImageView *headPic;
}

@end

@implementation personListViewController

#pragma mark - network method
///获取顶部帖子数量，参与数量数据
-(void)getHeaderData
{
    [BBSMainPresenters getgaminfo:userID_ updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                topDict = (NSDictionary *)data;
                [self setHeader];
            }else
            {
                topDict = @{};
                //[self showToastMsg:data Duration:5.0];
            }
            
            //填写数据
        });
    }];
}
-(void)getListData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNo];
    
    [BBSMainPresenters getPostList:@"-99" userid:userID_ sortkey:@"new" contype:@"0" posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:pageStr communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (tableView_.mj_header.isRefreshing) {
                [tableView_.mj_header endRefreshing];
            }
            if (tableView_.mj_footer.isRefreshing) {
                [tableView_.mj_footer endRefreshing];
            }
            
            if(resultCode==SucceedCode)
            {
//                [tableView_.pullToRefreshView stopAnimating];
//                [tableView_.infiniteScrollingView stopAnimating];
                if (pageNo == 1){
                    
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    
                    [tableView_ reloadData];
                }else{
                    
                    NSArray * tmparr = (NSArray *)data;
                    
                    if (tmparr.count == 0) {
                        
                        pageNo = pageNo - 1;
                    }else{
                        
                        NSInteger count = dataArray.count;
                        [dataArray addObjectsFromArray:tmparr];
                        
                        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                        for (int i = 0; i < tmparr.count; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                            [insertIndexPaths addObject:newPath];
                        }
                        [tableView_ beginUpdates];
                        [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [tableView_ endUpdates];
                        if (insertIndexPaths.count > 0) {
                            
                            [tableView_ scrollToRowAtIndexPath:insertIndexPaths[0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        }
                    }
                }
            }else
            {
//                [tableView_.pullToRefreshView stopAnimating];
//                [tableView_.infiniteScrollingView stopAnimating];
                if (pageNo != 1) {
                    
                    pageNo --;
                }else{
                    
                }
            }
            if (dataArray.count > 0) {
                
                holdView.hidden = YES;
                holdView.alpha = 0;
            }else{
                
                holdView.hidden = NO;
                holdView.alpha = 1;
            }
        });
    }];
}

#pragma mark - 点赞、取消点赞请求
- (void)httpRequestForPraiseOrNot:(NSInteger)isPraise withPostid:(NSString *)postid callBack:(void(^)(NSInteger praiseCount))callBack {
    
    [L_NewMinePresenters addPraiseType:isPraise withPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSString *count = [NSString stringWithFormat:@"%@",[[data objectForKey:@"map"] objectForKey:@"praisecount"]];
                
                [self showToastMsg:[data objectForKey:@"errmsg"] Duration:3.0];
                
                if ([count isKindOfClass:[NSString class]]) {
                    
                    NSInteger praiseNum = 0;
                    if (count.integerValue >= 0) {
                        praiseNum = count.integerValue;
                        if (callBack) {
                            callBack(praiseNum);
                        }
                    }
                    
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

#pragma mark - extend method

-(void)getuserID:(NSString *)userID{
    
    userID_ = userID;
}

-(void)configUI{
    
    tableView_= [[UITableView alloc]initWithFrame:CGRectMake( 10, 0, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - (44+statuBar_Height)) style:UITableViewStylePlain];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:tableView_];
    // ---------------头部参加人数和发帖数量
    
    [self setHeader];
    
    holdView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, tableView_.frame.size.width, tableView_.frame.size.height - headerView.frame.size.height)];
    holdView.backgroundColor = [UIColor clearColor];
    holdView.userInteractionEnabled = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake( 30, (holdView.frame.size.height - 80 ) / 2 - 50, holdView.frame.size.width - 30 * 2, 80)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:@"新版-无帖子"];
    [holdView addSubview:imgView];
    
    UILabel *errLal = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 30, imgView.frame.size.width, 20)];
    errLal.text = @"暂无帖子数据";
    errLal.font = [UIFont systemFontOfSize:15];
    errLal.textColor = [UIColor blackColor];
    errLal.textAlignment = NSTextAlignmentCenter;
//    [errLal setNumberOfLines:0];
//    [errLal sizeToFit];
    [holdView addSubview:errLal];
    
    holdView.hidden = YES;
    holdView.alpha = 0;
    
    [tableView_ addSubview:holdView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView_ reloadData];
    });
    [self getListData];
    
    /////////////////普通帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormalTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal0TableViewCell"];
    
    /////////////////广告帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvertTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert0TableViewCell"];
    
    /////////////////投票帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteTextTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteText2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteText2TableViewCell"];
    
    /////////////////问答帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionNoPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionNoPICTableViewCell"];
    
    /////////////////商品帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodityTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity1TableViewCell"];
    
    /////////////////房产帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
}

-(void)configNavigation{
    
    self.title = @"个人主页";
}

-(void)setHeader{
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView_.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backWhite = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, headerView.frame.size.width / 12 * 5)];
    backWhite.userInteractionEnabled = YES;
    backWhite.backgroundColor = [UIColor clearColor];
    backWhite.image = [UIImage imageNamed:@"个人主页背景"];
    
    [headerView addSubview:backWhite];
    
    float height = (backWhite.frame.size.height - 3 * 10) / 2;
    
    headPic = [[UIImageView alloc]initWithFrame:CGRectMake(10, backWhite.frame.size.height - 10 - height, height, height)];
    [headPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",topDict[@"userpicurl"]]] placeholderImage:[UIImage imageNamed:@"默认头像-方"]];
    headPic.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [headPic.layer setBorderWidth:1];
    [headPic.layer setBorderColor:CGColorRetain([UIColor whiteColor].CGColor)];
    headPic.userInteractionEnabled = YES;
    [backWhite addSubview:headPic];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderView:)];
    [headPic addGestureRecognizer:tap];
    
    followButton = [[UIButton alloc]initWithFrame:CGRectMake(backWhite.frame.size. width - 20 - headPic.frame.size.height / 3 / 40 * 142, 20, headPic.frame.size.height / 3 / 40 * 142, headPic.frame.size.height / 3)];
    
    if ([topDict[@"isme"] isEqual:@0]) {
        
        followButton.userInteractionEnabled = YES;
        if([topDict[@"isfollow"] isEqual:@0]){
            
            [followButton setBackgroundImage:[UIImage imageNamed:@"个人主页--加关注标签"] forState:UIControlStateNormal];
            type_ = 0;
        }else if([topDict[@"isfollow"] isEqual:@1]){
            
            [followButton setBackgroundImage:[UIImage imageNamed:@"个人主页-已关注标签"] forState:UIControlStateNormal];
            type_ = 1;
        }
        
    }else if ([topDict[@"isme"] isEqual:@1]){
        
        followButton.userInteractionEnabled = NO;
        [followButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    [followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    
    [backWhite addSubview:followButton];
    
    
    UILabel *nameLal = [[UILabel alloc]initWithFrame:CGRectMake(headPic.frame.origin.x + headPic.frame.size.width + 5, headPic.frame.origin.y, backWhite.frame.size.width / 2 - (headPic.frame.origin.x + headPic.frame.size.width + 5), headPic.frame.size.height / 3)];
    nameLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"nickname"]]];
    nameLal.backgroundColor = [UIColor clearColor];
    nameLal.textColor = [UIColor whiteColor];
    nameLal.textAlignment = NSTextAlignmentLeft;
    nameLal.font = [UIFont systemFontOfSize:13];
    [backWhite addSubview:nameLal];

    UIImageView *blueSexView = [[UIImageView alloc]initWithFrame:CGRectMake(nameLal.frame.origin.x, nameLal.frame.origin.y + nameLal.frame.size.height + 2, (nameLal.frame.size.height - 2) / 23 * 68, nameLal.frame.size.height - 2)];
    
    if ([topDict[@"sex"] isEqualToString:@"1"]) {
        
        blueSexView.image = [UIImage imageNamed:@"男性标签"];
    }else if ([topDict[@"sex"] isEqualToString:@"2"]){
    
        blueSexView.image = [UIImage imageNamed:@"女性标签"];
    }
    
    [backWhite addSubview:blueSexView];
    
    UILabel *ageLal = [[UILabel alloc]initWithFrame:CGRectMake(blueSexView.frame.size.width / 2, 0, blueSexView.frame.size.width / 2, blueSexView.frame.size.height)];
    ageLal.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"age"]]];
    ageLal.backgroundColor = [UIColor clearColor];
    ageLal.textColor = [UIColor whiteColor];
    ageLal.textAlignment = NSTextAlignmentLeft;
    ageLal.font = [UIFont systemFontOfSize:12];
    [blueSexView addSubview:ageLal];
    
    UIImageView *CertificationImg = [[UIImageView alloc]initWithFrame:CGRectMake(blueSexView.frame.origin.x, blueSexView.frame.origin.y + blueSexView.frame.size.height + 6, blueSexView.frame.size.height - 3, blueSexView.frame.size.height - 3)];
    
    if ([topDict[@"isowner"] isEqual:@0]) {
        
        CertificationImg.image = [UIImage imageNamed:@"我的-首页-业主认证图标-灰"];
    }else if ([topDict[@"isowner"] isEqual:@1]){
        
        CertificationImg.image = [UIImage imageNamed:@"邻趣-首页-物业认证图标"];
    }
    
    //邻趣-首页-物业认证图标
    
    [backWhite addSubview:CertificationImg];
    
    UILabel *CertificationLal = [[UILabel alloc]initWithFrame:CGRectMake(CertificationImg.frame.size.width + CertificationImg.frame.origin.x + 5, CertificationImg.frame.origin.y, backWhite.frame.size.width / 2 - blueSexView.frame.origin.x, CertificationImg.frame.size.height)];
    CertificationLal.text = @"业主认证";
    CertificationLal.backgroundColor = [UIColor clearColor];
    CertificationLal.textColor = [UIColor whiteColor];
    CertificationLal.textAlignment = NSTextAlignmentLeft;
    CertificationLal.font = [UIFont systemFontOfSize:12];
    [backWhite addSubview:CertificationLal];
    
    
    //---------发帖数量------------
    
    UILabel *postText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    postText.text = @"发帖";
    postText.backgroundColor = [UIColor clearColor];
    postText.textColor = [UIColor whiteColor];
    postText.textAlignment = NSTextAlignmentRight;
    postText.font = [UIFont systemFontOfSize:12];
    
    [postText setNumberOfLines:1];
    [postText sizeToFit];
    
    postText.center = CGPointMake(followButton.frame.size.width + followButton.frame.origin.x - postText.frame.size.width / 2 , CertificationLal.center.y);
    [backWhite addSubview:postText];
    
    UILabel *postNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    postNumber.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"postcount"]]];
    postNumber.backgroundColor = [UIColor clearColor];
    postNumber.textColor = [UIColor whiteColor];
    postNumber.textAlignment = NSTextAlignmentCenter;
    postNumber.font = [UIFont systemFontOfSize:12];
    
    [postNumber setNumberOfLines:1];
    [postNumber sizeToFit];
    
    postNumber.frame = CGRectMake(postText.frame.origin.x - 20 - postNumber.frame.size.width, postText.frame.origin.y, postNumber.frame.size.width + 10, postNumber.frame.size.height);
    [backWhite addSubview:postNumber];
    
    //---------访客数量-------------
    
    UILabel *personText = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 50, 20)];
    personText.text = @"访客";
    personText.backgroundColor = [UIColor clearColor];
    personText.textColor = [UIColor whiteColor];
    personText.textAlignment = NSTextAlignmentRight;
    personText.font = [UIFont systemFontOfSize:12];
    
    [personText setNumberOfLines:1];
    [personText sizeToFit];
    
    personText.center = CGPointMake(followButton.frame.size.width + followButton.frame.origin.x - postText.frame.size.width / 2, blueSexView.center.y);
    [backWhite addSubview:personText];
    
    UILabel *personNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    personNumber.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"pvcount"]]];
    personNumber.backgroundColor = [UIColor whiteColor];
    personNumber.textColor = [UIColor blackColor];
    personNumber.textAlignment = NSTextAlignmentCenter;
    personNumber.font = [UIFont systemFontOfSize:12];
    
    [personNumber setNumberOfLines:1];
    [personNumber sizeToFit];
    
    personNumber.layer.cornerRadius = personNumber.frame.size.height / 2;
    personNumber.layer.masksToBounds = YES;
    
    personNumber.frame = CGRectMake(personText.frame.origin.x - 20 - personNumber.frame.size.width, personText.frame.origin.y, personNumber.frame.size.width + 10, personNumber.frame.size.height);
    [backWhite addSubview:personNumber];
    
    UIButton *personBt = [[UIButton alloc]initWithFrame:CGRectMake(personNumber.frame.origin.x - 5, personNumber.frame.origin.y - 5, personText.frame.size.width + personText.frame.origin.x - personNumber.frame.origin.x + 5, postText.frame.origin.y + postText.frame.size.height + personNumber.frame.origin.y)];
    personBt.backgroundColor = [UIColor clearColor];
    [personBt addTarget:self action:@selector(personBt:) forControlEvents:UIControlEventTouchUpInside];
    
    [backWhite addSubview:personBt];
    
    //============关注粉丝私信=============
    
    UIView *backRed = [[UIView alloc]initWithFrame:CGRectMake(0, backWhite.frame.origin.y + backWhite.frame.size.height + 10, backWhite.frame.size.width, headPic.frame.size.height)];
    backRed.backgroundColor = kNewRedColor;
    [headerView addSubview:backRed];
    
    UILabel *attention = [[UILabel alloc]initWithFrame:CGRectMake( 10, 0, headPic.frame.size.width + 20, backRed.frame.size.height)];
    
    NSString *string;
    
    if ([XYString isBlankString:[NSString stringWithFormat:@"%@",topDict[@"followcount"]]]) {
        
        string = [NSString stringWithFormat:@"0 关注"];
    }else{
        
        string = [NSString stringWithFormat:@"%@ 关注",topDict[@"followcount"]];
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributeString addAttribute:NSFontAttributeName value:DEFAULT_FONT(17) range:NSMakeRange( 0,attributeString.length - 2)];
    [attributeString addAttribute:NSFontAttributeName value:DEFAULT_FONT(12) range:NSMakeRange( attributeString.length - 2, 2)];
    
    attention.attributedText = attributeString;
    attention.backgroundColor = [UIColor clearColor];
    [backRed addSubview:attention];
    
    UIButton *attentionBt = [[UIButton alloc]initWithFrame:attention.frame];
    attentionBt.backgroundColor = [UIColor clearColor];
    [attentionBt addTarget:self action:@selector(attentionBt:) forControlEvents:UIControlEventTouchUpInside];
    [backRed addSubview:attentionBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(attention.frame.origin.x + attention.frame.size.width + 5, 15, 3, backRed.frame.size.height - 2 * 15)];
    line.backgroundColor = TEXT_COLOR;
    [backRed addSubview:line];
    
    UILabel *fans = [[UILabel alloc]initWithFrame:CGRectMake( line.frame.origin.x + line.frame.size.width + 20, 0, headPic.frame.size.width + 20, backRed.frame.size.height)];
    
    NSString *string1;
    if ([XYString isBlankString:[NSString stringWithFormat:@"%@",topDict[@"tofollowcount"]]]) {
        
        string1 = [NSString stringWithFormat:@"0 粉丝"];
    }else{
        
        string1 = [NSString stringWithFormat:@"%@ 粉丝",topDict[@"tofollowcount"]];
    }
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc]initWithString:string1 attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributeString1 addAttribute:NSFontAttributeName value:DEFAULT_FONT(17) range:NSMakeRange( 0,attributeString1.length - 2)];
    [attributeString1 addAttribute:NSFontAttributeName value:DEFAULT_FONT(12) range:NSMakeRange( attributeString1.length - 2, 2)];
    
    fans.attributedText = attributeString1;
    fans.backgroundColor = [UIColor clearColor];
    [backRed addSubview:fans];
    
    UIButton *fansBt = [[UIButton alloc]initWithFrame:fans.frame];
    fansBt.backgroundColor = [UIColor clearColor];
    [fansBt addTarget:self action:@selector(fansBt:) forControlEvents:UIControlEventTouchUpInside];
    [backRed addSubview:fansBt];
    
    
    UIButton *letterButton = [[UIButton alloc]initWithFrame:CGRectMake(backRed.frame.size.width - 20 - backRed.frame.size.height / 2 * 4, backRed.frame.size.height / 4, backRed.frame.size.height / 2 * 4, backRed.frame.size.height / 2)];
    
    if ([topDict[@"isme"] isEqual:@0]) {
        
        letterButton.userInteractionEnabled = YES;
        [letterButton setBackgroundImage:[UIImage imageNamed:@"个人主页-私信他"] forState:UIControlStateNormal];
    }else if ([topDict[@"isme"] isEqual:@1]){
    
        letterButton.userInteractionEnabled = NO;
        [letterButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    letterButton.backgroundColor = [UIColor clearColor];
    [letterButton addTarget:self action:@selector(letter:) forControlEvents:UIControlEventTouchUpInside];
    [backRed addSubview:letterButton];

    
    headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, backRed.frame.origin.y + backRed.frame.size.height + 10);
    tableView_.tableHeaderView = headerView;
}

#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return headPic.image;
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",topDict[@"userpicurl"]]];
    
}

#pragma mark - button tap method

-(void)tapHeaderView:(id)sender{
    
    SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
    browser.sourceImagesContainerView = self.view;
    browser.imageCount = 1;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

-(void)personBt:(id)sender{
    
//    NSString *userid = topDict[@"userid"];
    
    if ([XYString isBlankString:userID_]) {
        return;
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
    L_BBSVisitorsListViewController *visitorVC = [storyBoard instantiateViewControllerWithIdentifier:@"L_BBSVisitorsListViewController"];
    visitorVC.userid = userID_;
    [self.navigationController pushViewController:visitorVC animated:YES];
    
}

-(void)follow:(id)sender{//关注他
    
    [L_NewMinePresenters addFollowWithUserid:userID_ type:type_ UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode) {
                
                if (type_ == 0) {
                    
                    [followButton setBackgroundImage:[UIImage imageNamed:@"个人主页-已关注标签"] forState:UIControlStateNormal];
                    type_ = 1;
                    if (![XYString isBlankString:data[@"errmsg"]]) {
                        [self showToastMsg:data[@"errmsg"] Duration:3.0];
                    }else {
                        [self showToastMsg:@"关注成功" Duration:3.0];
                    }
                }else if (type_ == 1){
                    
                    [followButton setBackgroundImage:[UIImage imageNamed:@"个人主页--加关注标签"] forState:UIControlStateNormal];
                    type_ = 0;
                    if (![XYString isBlankString:data[@"errmsg"]]) {
                        [self showToastMsg:data[@"errmsg"] Duration:3.0];
                    }else {
                        [self showToastMsg:@"取消关注" Duration:3.0];
                    }
                }
            }else
            {
                [self showToastMsg:data Duration:3.0];
            }
            
            //填写数据
        });
    }];
}

-(void)letter:(id)sender{//私信他

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([XYString isBlankString:userID_]) {
            [self showToastMsg:@"获得用户信息失败" Duration:3.0];
            return;
        }
        AppDelegate *appDelegate = GetAppDelegates;
        if ([userID_ isEqualToString:appDelegate.userData.userID]) {
            [self showToastMsg:@"不能和自己聊天" Duration:3.0];
            return;
        }
        
        ChatViewController *chatC =[[ChatViewController alloc]initWithChatType:XMMessageChatSingle];
        chatC.navigationItem.title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"nickname"]]];
        chatC.ReceiveID = userID_;
        
        [self.navigationController pushViewController:chatC animated:YES];
    });
}

-(void)attentionBt:(id)sedner{//关注列表
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ///关注
        MyFollowVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFollowVC"];
        mfVC.userid = [topDict objectForKey:@"userid"];
        mfVC.username = [topDict objectForKey:@"nickname"];
        
        [self.navigationController pushViewController:mfVC animated:YES];
    });
}

-(void)fansBt:(id)sender{//粉丝列表
    
    dispatch_async(dispatch_get_main_queue(), ^{

        ///我的粉丝
        MyFansVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFansVC"];
        mfVC.userid = [topDict objectForKey:@"userid"];
        mfVC.username = [topDict objectForKey:@"nickname"];
        [self.navigationController pushViewController:mfVC animated:YES];
    });
}

#pragma mark - life cycle method

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"gerenzhuye"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GerenZhuYe];
    
    [self getHeaderData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"gerenzhuye"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GerenZhuYe}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDlgt = GetAppDelegates;
    pageNo = 1;
    listType = 2;
    topDict = @{};
    dataArray = [[NSMutableArray alloc]init];
    
    [self configNavigation];
    [self configUI];
    
    @WeakObj(self);
    
    tableView_.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        pageNo = 1;
        [selfWeak getHeaderData];
        [selfWeak getListData];
    }];
    
    tableView_.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNo = pageNo + 1;
        [selfWeak getListData];
    }];
    
    [tableView_.mj_footer setAutomaticallyHidden:YES];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = [dataArray objectAtIndex:indexPath.row];
    
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = dataArray[indexPath.row];
    NSLog(@"%@-----%@",model.redtype,model.content);
    //    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section],[indexPath row]];//以indexPath来唯一确定cell
    
    @WeakObj(self);
    
    if ([model.posttype isEqualToString:@"0"]) {///////////////////普通帖
        
        if (model.piclist.count >= 3) {//3图普通帖
            
            BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];
            
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图普通帖
            
            BBSNormal2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图普通帖
            
            BBSNormal1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else if (model.piclist.count == 0){//无图普通帖
            
            BBSNormal0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal0TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"5"]) {///////////////////////广告贴
        
        if([model.advtype isEqualToString:@"100"]){
            
            BBSAdvert0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert0TableViewCell"];
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([model.advtype isEqualToString:@"101"]){
            
            if (model.piclist.count >= 3) {//3图广告贴
                
                BBSAdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvertTableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else if (model.piclist.count == 2){//2图广告贴
                
                BBSAdvert2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert2TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
                
            }else if (model.piclist.count == 1){//1图广告贴
                
                BBSAdvert1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert1TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
            }
        }
    }else if ([model.posttype isEqualToString:@"2"]) {///////////////////////投票贴
        if ([model.pictype isEqualToString:@"1"]) {//3图投票贴
            
            if (model.itemlist.count >= 3) {
                
                BBSVotePICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePICTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
            }else if (model.itemlist.count == 2){//2图投票贴
                
                BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
                
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }else if ([model.pictype isEqualToString:@"0"]){//文字投票贴
            
            if(model.itemlist.count >= 3){
                
                BBSVoteTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteTextTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
            }else if(model.itemlist.count == 2){
                
                BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"3"]) {///////////////////////问答贴
        if (model.piclist.count >= 3) {//3图问答贴
            
            BBSQuestionPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPICTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图问答贴
            
            BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图问答贴
            
            BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 0){//文字问答贴
            
            BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
        if (model.piclist.count >= 3) {//3图房产贴
            
            BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图房产贴
            
            BBSHouse2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图房产贴
            
            BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else if (model.piclist.count == 0){//0图房产贴
            
            BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"1"]) {///////////////////////商品贴
        
        if (model.piclist.count >= 3) {//3图商品贴
            
            BBSCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodityTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图商品贴
            
            BBSCommodity2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图商品贴
            
            BBSCommodity1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (model.posttype.integerValue == 9) {//活动分享
        
        //=========活动分享到邻趣======================
        L_ShareActivityTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ShareActivityTVC"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = model;
        
        @WeakObj(cell);
        cell.cellBtnDidClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            //1.头像 2.点赞 3.社区
            if (index == 1) {
                [self gotoCommunityWebviewWithModel:model withListType:1];
            }
            
            if (index == 2) {
                
                NSInteger isPraise = 0;
                if (model.ispraise.integerValue == 0) {
                    isPraise = 0;
                }else {
                    isPraise = 1;
                }
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.dianzan_Label.text = model.praisecount;
                        
                    });
                    
                }];
                
            }
            
            if (index == 3) {
                [self gotoCommunityWebviewWithModel:model withListType:2];
            }
            
        };
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = dataArray[indexPath.row];
    
    if (model.posttype.integerValue == 0) {//普通帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
        normalDetailVC.postID = model.theid;
        
        normalDetailVC.deleteRefreshBlock = ^(){
            
            [dataArray removeObject:model];
            [tableView_ reloadData];
            
        };
        
        normalDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            if (![XYString isBlankString:praise]) {
                
                model.praisecount = praise;
            }
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            if (![XYString isBlankString:type]) {
                if (type.integerValue == 0) {
                    model.ispraise = @"1";
                }else {
                    model.ispraise = @"0";
                }
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        
        [self.navigationController pushViewController:normalDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 4) {//房产车位帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
        houseDetailVC.postID = model.theid;
        houseDetailVC.bbsModel = model;
        
        houseDetailVC.deleteRefreshBlock = ^(){
            
            [dataArray removeObject:model];
            [tableView_ reloadData];
        };
        
        houseDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            if (![XYString isBlankString:praise]) {
                
                model.praisecount = praise;
            }
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            if (![XYString isBlankString:type]) {
                if (type.integerValue == 0) {
                    model.ispraise = @"1";
                }else {
                    model.ispraise = @"0";
                }
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        [self.navigationController pushViewController:houseDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 3) {//问答帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
        qusetion.postID = model.theid;
        
        qusetion.deleteRefreshBlock = ^(){
            
            [dataArray removeObject:model];
            [tableView_ reloadData];
            
        };
        
        qusetion.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        [self.navigationController pushViewController:qusetion animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 9) {//活动分享
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
        
        if([model.sharegotourl hasSuffix:@".html"]) {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
        }else {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
        }
        
        //        webVc.url = [NSString stringWithFormat:@"%@",model.sharegotourl];
        webVc.type = 5;
        webVc.shareTypes = 5;
        
        UserActivity *userModel = [[UserActivity alloc]init];
        userModel.gotourl = [NSString stringWithFormat:@"%@",model.sharegotourl];
        webVc.userActivityModel = userModel;
        
        if (![XYString isBlankString:model.title]) {
            webVc.title = model.title;
        }else {
            webVc.title = @"活动详情";
        }
        webVc.isGetCurrentTitle = YES;
        
        webVc.talkingName = @"shequhuodong";
        
        [self.navigationController pushViewController:webVc animated:YES];
        
    }
    
}

/**
 进入社区帖子,进入个人中心 listtype==2为社区帖子
 */
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model withListType:(NSInteger)listtype {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if (listType == 2) {
        
        CommunityListViewController *CommunityList = [[CommunityListViewController alloc]init];
        [CommunityList getCommunityID:model.communityid communityName:model.communityname];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CommunityList animated:YES];
    }else {
        
        if([appDlgt.userData.url_gamuserindex hasSuffix:@".html"]) {
            
            webVc.url=[NSString stringWithFormat:@"%@?token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,model.userid];
            webVc.isGetCurrentTitle = YES;
            webVc.title = @"个人主页";
        }else {
            
            webVc.url=[NSString stringWithFormat:@"%@&token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,model.userid];
            webVc.isGetCurrentTitle = YES;
            webVc.title = @"个人主页";
        }
        [self.navigationController pushViewController:webVc animated:YES];
    }
}


@end
