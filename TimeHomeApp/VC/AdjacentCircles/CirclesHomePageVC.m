//
//  CirclesHomePageVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CirclesHomePageVC.h"

///vcs
#import "PersonalDataVC.h"
#import "ActionSheetVC.h"
#import "WebViewVC.h"
#import "ChatViewController.h"
#import "BlacklistVC.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
///cells
#import "DynamicImgCell.h"

///views
#import "CircleFooterView.h"
#import "HomePageHeaderCell.h"

///models
#import "PostPresenter.h"
#import "TopicPostModel.h"
#import "DateTimeUtils.h"
#import "ChatPresenter.h"
#import "UserInfoMotifyPresenters.h"
#import "SharePresenter.h"

@interface CirclesHomePageVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray * homePageArr;
    NSInteger page;
    
}
@property (strong, nonatomic)UICollectionView *collectionV;

@end

@implementation CirclesHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    homePageArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) collectionViewLayout:flowlayout];
    [self.collectionV setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"DynamicImgCell" bundle:nil] forCellWithReuseIdentifier:@"DynamicImgCell"];
    
    
    

    [self.collectionV registerNib:[UINib nibWithNibName:@"HomePageHeaderCell" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"CircleFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"];
    [self.view addSubview:self.collectionV];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    page = 1 ;
    
    @WeakObj(self)
    [PostPresenter getTopicUserPosts:^(id  _Nullable data, ResultCode resultCode) {
        

        dispatch_async(dispatch_get_main_queue(), ^{

            if (resultCode == SucceedCode) {
                
                NSLog(@"data==%@",data);
                
                if (page ==1) {
                    [homePageArr removeAllObjects];
                }
                [homePageArr addObjectsFromArray:data];
                selfWeak.collectionV.hidden = NO;
                selfWeak.nothingnessView.hidden = YES;
                [selfWeak.collectionV reloadData];
                
            }else
            {
                
                selfWeak.collectionV.hidden = YES;
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"Ta还没有发表过帖子" eventCallBack:nil];

                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                
            }
            
            
        });
        
        
    } withPage:@"1" withUserID:_userID];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDelgate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DynamicImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DynamicImgCell" forIndexPath:indexPath];
    TopicPostModel * TPML =    [homePageArr objectAtIndex:indexPath.section];
    NSDictionary * picDic = [TPML.piclist objectAtIndex:indexPath.row];
    [cell setBackgroundColor:BLACKGROUND_COLOR];
    
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[picDic objectForKey:@"fileurl"]] placeholderImage:PLACEHOLDER_IMAGE];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 56);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    TopicPostModel * TPML =    [homePageArr objectAtIndex:section];

    if (section == 0) {
        if (TPML.cellHight>200) {
            
            return CGSizeMake(SCREEN_WIDTH, 200+230-36);

        }
        return CGSizeMake(SCREEN_WIDTH, TPML.cellHight+230-36);
    }
    
    if (TPML.cellHight>200) {
        
        return CGSizeMake(SCREEN_WIDTH, 200+100-36);
        
    }
    return CGSizeMake(SCREEN_WIDTH,TPML.cellHight+100-36);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TopicPostModel * TPML = [homePageArr objectAtIndex:indexPath.section];
    
    switch (TPML.piclist.count) {
        case 0:
        {
            
            return CGSizeMake(0,0);
        }
            break;
        case 1:
        {
            return CGSizeMake(SCREEN_WIDTH-collection_interval,(SCREEN_WIDTH-collection_interval)/2.0f);
        }
            break;
        case 2:
        {
            return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f,(SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f);
        }
            break;
        case 3:
        {
            return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            
        }
            break;
        case 4:
        {
            if (indexPath.row==3) {
                
                return CGSizeMake(SCREEN_WIDTH-collection_interval,(SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            }
            
        }
            break;
        case 5:
        {
            if (indexPath.row==3||indexPath.row==4) {
                
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f,(SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            }
            
        }
            break;
            
        case 6:
        {
            return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            
        }
            break;
        case 7:
        {
            if (indexPath.row==6) {
                
                return CGSizeMake(SCREEN_WIDTH-collection_interval,(SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            }
            
            
        }
            break;
        case 8:
        {
            if (indexPath.row==6||indexPath.row==7) {
                
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f,(SCREEN_WIDTH-collection_interval-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            }
            
        }
            break;
        case 9:
        {
            return CGSizeMake((SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f,(SCREEN_WIDTH-collection_interval-cell_interval*4)/3.0f);
            
        }
            break;
        default:
        {
            return CGSizeMake(0,0);
            
        }
            break;
    }

//    return CGSizeMake((SCREEN_WIDTH-30-20)/3.0,(SCREEN_WIDTH-30-20)/3.0);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TopicPostModel * TPML = [homePageArr objectAtIndex:section];

    return TPML.piclist.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return homePageArr.count;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        HomePageHeaderCell * circleHeaderView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"forIndexPath:indexPath];
        TopicPostModel * TPML = [homePageArr objectAtIndex:indexPath.section];
        circleHeaderView.titleLb.text = TPML.title;
        circleHeaderView.indexPath = indexPath;
        
        if (indexPath.section == 0) {
            @WeakObj(self)
            circleHeaderView.block = ^(id  _Nullable data,ResultCode resultCode)
            {
                if (resultCode == 1) {
                    
                    AppDelegate * tempApp = GetAppDelegates;
                    if([selfWeak.UIML.userID isEqualToString:tempApp.userData.userID]){
                        [selfWeak showToastMsg:@"不能和自己聊天！" Duration:2.5f];
                    }else
                    {
                        ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
                        chatC.ReceiveID = TPML.userid;
                        [selfWeak.navigationController pushViewController:chatC animated:YES];
                    }

                }else if(resultCode == 2)
                {
                    UIButton * tempBtn = (UIButton *)data;
                    [tempBtn setEnabled:NO];
                    if (selfWeak.UIML.isfllow.boolValue) {
                        ///取消关注
//                        [ChatPresenter removeUserFollow:TPML.userid withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [tempBtn setEnabled:YES];
//                                [selfWeak showToastMsg:data Duration:2.5];
//                                selfWeak.UIML.isfllow = @"0";
//                                [selfWeak.collectionV reloadData];
//
//                                
//                            });
//                        }];
                        
                        
                        
                    }else
                    {
                        ///关注
//                        [ChatPresenter addUserFollow:TPML.userid withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [tempBtn setEnabled:YES];
//
//                                [selfWeak showToastMsg:data Duration:2.5];
//                                selfWeak.UIML.isfllow = @"1";
//                                [selfWeak.collectionV reloadData];
//                            });
//                        }];
                        
                    }

                    
                    
                }
            };
            
           
            
            if (selfWeak.UIML.isfllow.boolValue) {
               
                [circleHeaderView.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
                [circleHeaderView.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }else
            {
              
                [circleHeaderView.followBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
                [circleHeaderView.followBtn setTitle:@"加关注" forState:UIControlStateNormal];
                

            }
            [circleHeaderView.view_1 setHidden:NO];
            circleHeaderView.view_1_H.constant = 130;
            circleHeaderView.ageLb.text = TPML.age;
            if(TPML.sex.integerValue == 1)
            {
                [circleHeaderView.sexImg setImage:[UIImage imageNamed:@"邻圈_男"]];
                [circleHeaderView.ageV   setBackgroundColor:MAN_COLOR];
                
            }else if(TPML.sex.integerValue == 2)
            {
                [circleHeaderView.sexImg setImage:[UIImage imageNamed:@"邻圈_女"]];
                [circleHeaderView.ageV   setBackgroundColor:WOMEN_COLOR];
            }
            circleHeaderView.levelLb.text = self.UIML.level;
            
            circleHeaderView.signatureLb.text = self.UIML.signature;
            [circleHeaderView.imgV sd_setImageWithURL:[NSURL URLWithString:TPML.userpic]placeholderImage:PLACEHOLDER_IMAGE];
            
        }else
        {
         
            [circleHeaderView.view_1 setHidden:YES];
             circleHeaderView.view_1_H.constant = 0;
        }
        
        circleHeaderView.contentBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
            NSString * typeStr = data;
            
            
            TopicPostModel * TPML_1 = [homePageArr objectAtIndex:index.section ];
            
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            NSString * urlStr;
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            if (typeStr.integerValue == 1) {
                
                urlStr = TPML_1.topicgotourl;
                
                webVc.type= 1;
                webVc.topicid = TPML_1.topicid;
                
            }else if (typeStr.integerValue == 2) {
                
                urlStr = TPML_1.postsgotourl;
                webVc.TPML = TPML_1;
                webVc.type= 2;

            }

            AppDelegate *appDlgt=GetAppDelegates;
            if([urlStr hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",urlStr,appDlgt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",urlStr,appDlgt.userData.token];
            }
            
            //                        webVc.url = TPML_1.gotourl;
            webVc.title = TPML_1.webtitle;
            [self.navigationController pushViewController:webVc animated:YES];
            
        };
        
        NSString * newSystime = [TPML.systime substringWithRange:NSMakeRange(0,19)];
        circleHeaderView.timeLB.text = [DateTimeUtils StringFromDateTime:[XYString  NSStringToDate:newSystime]];
        circleHeaderView.contentLb.attributedText = TPML.contentAttriStr;
        return circleHeaderView;
        
        
    }else if([kind isEqual:UICollectionElementKindSectionFooter]){
        
        CircleFooterView *circleFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"forIndexPath:indexPath];
        [circleFooterView setBackgroundColor:BLACKGROUND_COLOR];
        circleFooterView.indexPath = indexPath;
        @WeakObj(self)
        
        ///评论
        circleFooterView.replayBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            TopicPostModel * TPML = [homePageArr objectAtIndex:index.section];
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            
            AppDelegate *appDlgt=GetAppDelegates;
            if([TPML.postsgotourl hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",TPML.postsgotourl,appDlgt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",TPML.postsgotourl,appDlgt.userData.token];
            }
            //            webVc.url = TPML.postsgotourl;
            webVc.title = TPML.webtitle;
            [self.navigationController pushViewController:webVc animated:YES];
            
        };
        ///点赞
        circleFooterView.praiseBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            TopicPostModel * TPML = [homePageArr objectAtIndex:index.section];
            if(TPML.ispraised.boolValue){
                [PostPresenter removeTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TPML.ispraised = @"0";
                        TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue -1)];
                        [selfWeak.collectionV reloadData];
                        
                    });
                    
                } withTopicID:TPML.postsid];
                
            }else
            {
                [PostPresenter addTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TPML.ispraised = @"1";
                        TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue +1)];
                        
                        [selfWeak.collectionV reloadData];
                        
                    });
                    
                } withTopicID:TPML.postsid];
            }
            
        };
        
        TopicPostModel * TPML = [homePageArr objectAtIndex:indexPath.section];
        circleFooterView.praiseCountLB.text = TPML.praisecount;
        circleFooterView.replayCountLB.text = TPML.commentcount;
        if(TPML.ispraised.boolValue){
            
            [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_已点赞"] forState:UIControlStateNormal];
            
        }else
        {
            [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_点赞"] forState:UIControlStateNormal];
            
        }

        circleFooterView.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            [ActionSheetVC shareActionSheet].data = @[@"转发",@"举报",@"取消"];
            [[ActionSheetVC shareActionSheet] showInVC:self];

            [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
            {
                NSLog(@"----%ld----",index.row);
                if (index.row == 1) {
                    
                    [ActionSheetVC shareActionSheet].data = @[@"骚扰信息",@"虚假身份",@"广告欺诈",@"不当发言",@"取消"];
                    [[ActionSheetVC shareActionSheet] updateTable];
                    [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
                    {
                        [[ActionSheetVC shareActionSheet] dismiss];
                        if (![XYString isBlankString:TPML.userid]) {
                            if (index.row < 4) {
                                
                                
                                [PostPresenter addPostsReport:TPML.postsid withType:[NSString stringWithFormat:@"%ld",index.row] andSource:@"1" andCallBack:^(id  _Nullable data, ResultCode resultCode) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if(resultCode == SucceedCode)
                                        {
                                            [selfWeak showToastMsg:@"举报成功" Duration:2.0];
                                        }
                                        else
                                        {
                                            [selfWeak showToastMsg:@"举报失败" Duration:2.0];
                                        }
                                        
                                    });
                                    
                                }];

//                                [UserInfoMotifyPresenters addUserReportUserID:TPML.userid type:[NSString stringWithFormat:@"%ld",index.row] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//                                    
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        
//                                        if(resultCode == SucceedCode)
//                                        {
//                                            [selfWeak showToastMsg:@"举报成功" Duration:2.0];
//                                        }
//                                        else
//                                        {
//                                            [selfWeak showToastMsg:(NSString *)data Duration:2.0];
//                                        }
//                                        
//                                    });
//                                    
//                                }];
                            }
                        }
                        
                    };

                }else if(index.row == 0)
                {
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.shareTitle = TPML.content_ls;
                    SCML.shareImg=SHARE_LOGO_IMAGE;
                    if(TPML.piclist.count>0)
                    {
                        NSString * url = [[TPML.piclist firstObject] objectForKey:@"fileurl"];;
                        SCML.shareImg = url;
                        
                    }

                    SCML.shareContext = @" ";
                    SCML.shareUrl= TPML.postsgotourl;
                    SCML.type = 4;
                    SCML.shareSuperView = self.view;
                    SCML.shareType = SSDKContentTypeWebPage;
//                    SCML.shareType = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];
                    [[ActionSheetVC shareActionSheet] dismiss];
                    
                }else
                {
                    [[ActionSheetVC shareActionSheet] dismiss];

                }
            };
            
        };
        
        return circleFooterView;
        
    }else
    {
        return [UICollectionReusableView new];
    }
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0.1;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0.1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicImgCell * cell = (DynamicImgCell * )[collectionView cellForItemAtIndexPath:indexPath];
    [self tapPicture:indexPath tapView:cell.imgV];
}
#pragma mark - 点击图片
-(void)tapPicture :(NSIndexPath *)index
          tapView :(UIImageView *)tapView
{
    
    TopicPostModel * TPML = [homePageArr objectAtIndex:index.section];
    NSInteger count = TPML.piclist.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++) {
        
        NSString *url;
        MJPhoto *photo = [[MJPhoto alloc] init];
        url = [[TPML.piclist objectAtIndex:i] objectForKey:@"fileurl"];;
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    
}

@end
