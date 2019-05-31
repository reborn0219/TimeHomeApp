//
//  L_HouseDetailsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailsViewController.h"

#import "BBSMainPresenters.h"
#import "L_NewMinePresenters.h"

#import "SharePresenter.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "PostPresenter.h"
#import "ActionSheetVC.h"
#import "MessageAlert.h"

//TVC
#import "L_HouseImageTVC.h"
#import "L_HouseDetailsFirstTVC.h"
#import "L_HouseDetailSecondTVC.h"
#import "L_HouseDetailThirdTVC.h"
#import "L_HouseDetailForthTVC.h"
#import "L_NormalDetailCommentTVC.h"

#import "L_CommentListViewController.h"
#import "personListViewController.h"
#import "ChatViewController.h"
#import "RedPacketsAlertVC.h"
#import "RedPacketsVC.h"
#import "PraiseListVC.h"

CGFloat const kHouseCommentInputViewHeight = 50.0f;
CGFloat const kHouseCommentInputTextViewHeight = 34.0f;

NSInteger const HouseMAX_LIMIT_NUMS = 2000;/** 评论字数限制 */

@interface L_HouseDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SDPhotoBrowserDelegate>
{
    CGSize _currentTextViewContentSize;
    NSInteger _textLine;
    CGRect keyboardF;
    UILabel *placeHolder;
    BOOL isRefreshBeginning;
    BOOL isFirstInVC;//第一次进入
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFBgViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFBgViewHeightConstraint;

/**
 输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;

/**
 收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

/**
 输入框背景
 */
@property (weak, nonatomic) IBOutlet UIView *TFBgView;

@property (nonatomic, strong) L_HouseDetailModel *houseDetailModel;

@property (nonatomic, assign) NSInteger page;
/**
 当前帖子下面显示的评论
 */
@property (nonatomic, strong) NSMutableArray *commentArray;

/**
 帖子详情字典
 */
@property (nonatomic, strong) NSDictionary *contentDictionary;

/**
 红包图片
 */
@property (nonatomic, strong) UIButton *redButton;

@end

@implementation L_HouseDetailsViewController

// MARK: - 返回按钮点击
/**
 返回按钮点击
 */
- (void)backButtonClick {
    if (_isFromCommentPush) {
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else {
        [super backButtonClick];
    }
}

// MARK: - 获取红包状态
/**
 获取红包状态
 
 @param redID 红包id
 */
- (void)httpRequestForGetRedStateWithRedid:(NSString *)redID {
    
    if (!isFirstInVC) {
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    }
    
    [BBSMainPresenters getRedState:redID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!isFirstInVC) {
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            }

            if (resultCode == SucceedCode) {
                //                errcode	0 成功
                //                errmsg	错误提示
                //                map	信息
                //                        id	红包id
                //                        state	红包状态0 进行中、 1 已领完、- 1 已过期、-2 已关闭、- 99已删除
                //                        isreceive	是否领取 0 否 1 是
                
                NSDictionary *dict = (NSDictionary *)data;
                
                if (isFirstInVC) {
                    
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 0) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"1",@"userpic":_houseDetailModel.userpicurl,@"nickname":_houseDetailModel.nickname,@"redid":_houseDetailModel.redid}];
                        
                    }
                    
                }else {
                    
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 0) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"1",@"userpic":_houseDetailModel.userpicurl,@"nickname":_houseDetailModel.nickname,@"redid":_houseDetailModel.redid}];
                        
                    }
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 1) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"2",@"userpic":_houseDetailModel.userpicurl,@"nickname":_houseDetailModel.nickname,@"redid":_houseDetailModel.redid}];
                        
                    }
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == -1) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"3",@"userpic":_houseDetailModel.userpicurl,@"nickname":_houseDetailModel.nickname,@"redid":_houseDetailModel.redid}];
                        
                    }
                    if ([dict[@"map"][@"isreceive"] integerValue] == 1 || [dict[@"map"][@"state"] integerValue] == -2 || [dict[@"map"][@"state"] integerValue] == -99) {
                        //跳转红包详情列表
                        [self gotoRedInfoVC];
                    }

                }
                
            }else {

                [self showToastMsg:data Duration:3.0];
            }
            isFirstInVC = NO;

        });
        
    }];
    
}

// MARK: - 评论列表
/**
 评论列表
 */
- (void)httpRequestForCommentListIsRefresh:(BOOL)isRefresh isComment:(BOOL)isComment {
    
    if (isRefresh) {
        _page = 1;
        
        isRefreshBeginning = YES;
        
    }else {
        
        if (isRefreshBeginning == YES) {
            [_tableView.mj_footer endRefreshing];
            return;
        }
        
        _page++;
    }
    
    [BBSMainPresenters getCommentWithID:_postID withPage:_page updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView.mj_footer endRefreshing];
            
            if (resultCode == SucceedCode) {
                
                NSArray *array = [L_TieziCommentModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
                
                isRefreshBeginning = NO;

                if (_page == 1) {
                    [_commentArray removeAllObjects];
                }
                if (((NSArray *)array).count > 0) {
                    [_commentArray addObjectsFromArray:array];
                    [_tableView reloadData];
                    
                    if (isComment) {
                        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
                NSInteger errcode=[[data objectForKey:@"errcode"]intValue];
                if (errcode == 99999) {
                    if (_page > 1) {
                        _page = _page - 1;
                    }
                }
                
            }else {
                
                if (isRefresh) {
                    _page = 1;
                }else {
                    _page = _page - 1;
                }
                
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 获得帖子详情
/**
 获得帖子详情
 */
- (void)httpRequestForGetInfoIsComment:(BOOL)isComment {
    
    [BBSMainPresenters getHousePostInfoWithID:_postID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
//                _tableView.alpha = 1;

                _contentDictionary = data[@"map"];
                
                _houseDetailModel = [L_HouseDetailModel mj_objectWithKeyValues:data[@"map"]];
                [_tableView reloadData];
                
                if (_houseDetailModel.housetype.integerValue == 10 || _houseDetailModel.housetype.integerValue == 11) {
                    self.navigationItem.title = @"房产帖详情";
                }else if (_houseDetailModel.housetype.integerValue == 30 || _houseDetailModel.housetype.integerValue == 31){
                    self.navigationItem.title = @"车位帖详情";
                }else {
                    self.navigationItem.title = @"";
                }
                
                if (_houseDetailModel.iscollect.integerValue == 0) {
                    [_collectionButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-灰"] forState:UIControlStateNormal];
                }else {
                    [_collectionButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-"] forState:UIControlStateNormal];
                }
                
                if (_houseDetailModel.redtype.integerValue == 0) {
                    _redButton.hidden = NO;
                }else {
                    _redButton.hidden = YES;
                }
                
                if (isFirstInVC) {
                    [self httpRequestForGetRedStateWithRedid:_houseDetailModel.redid];
                }
                [self httpRequestForCommentListIsRefresh:YES isComment:isComment];

            }else {
                [self showToastMsg:data Duration:3.0];
            }

        });
        
    }];
    
}

// MARK: - 删除帖子
/**
 删除帖子
 
 @param model
 */
- (void)httpRequestForDeleteWithPostid:(NSString *)postid {
    
    if ([XYString isBlankString:postid]) {
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_NewMinePresenters deletePostWithPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                if (self.deleteRefreshBlock) {
                    self.deleteRefreshBlock();
                }
                
                [self showToastMsg:@"贴子删除成功!" Duration:3.0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

// MARK: - 点赞
/**
 点赞
 
 @param type 0点赞 1取消点赞
 @param postid 帖子id
 */
- (void)httpRequestForPraiseType:(NSInteger)type withPostid:(NSString *)postid {
    
    [L_NewMinePresenters addPraiseType:type withPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSMutableArray *praiseArray = [[NSMutableArray alloc] initWithArray:_houseDetailModel.praiselist];
                AppDelegate *appDlgt = GetAppDelegates;
                if (type == 0) {
                    
                    _houseDetailModel.ispraise = @"1";
                    [praiseArray insertObject:@{@"userid":appDlgt.userData.userID,@"userpicurl":appDlgt.userData.userpic} atIndex:0];
                    
                }else {
                    _houseDetailModel.ispraise = @"0";
                    for (NSDictionary *praiseDict in _houseDetailModel.praiselist) {
                        if ([praiseDict[@"userid"] isEqualToString:appDlgt.userData.userID]) {
                            [praiseArray removeObject:praiseDict];
                        }
                    }
                }
                _houseDetailModel.praiselist = [praiseArray copy];
                _houseDetailModel.praisecount = [NSString stringWithFormat:@"%@",data[@"map"][@"praisecount"]];
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                
                if (self.praiseAndCommentCallBack) {
                    //type 0已点赞 1 未点赞
                    self.praiseAndCommentCallBack(_houseDetailModel.praisecount,nil,nil,[NSString stringWithFormat:@"%ld",(long)type]);
                    
                }
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 回复评论
/**
 回复评论
 
 @param content 回复内容
 */
- (void)httpRequestForAddCommentWithContent:(NSString *)content {
    
    NSString *string = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([XYString isBlankString:string]) {
        [self showToastMsg:@"回复内容不能为空" Duration:3.0];
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters addCommentWithID:_postID withContent:content withCommentID:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                _textView.text = @"";
                _currentTextViewContentSize = _textView.contentSize;
                _TFBgViewHeightConstraint.constant = 50;
                _TFBgViewBottomConstraint.constant = 0;
                if (kDevice_Is_iPhoneX) {
                    _TFBgViewBottomConstraint.constant = bottomSafeArea_Height;
                }
                NSString *commentCount = [NSString stringWithFormat:@"%@",data[@"map"][@"commentcount"]];
                
                if (self.praiseAndCommentCallBack) {
                    
                    self.praiseAndCommentCallBack(nil,commentCount,nil,nil);
                }
                
                [self showToastMsg:@"评论成功" Duration:3.0];
                
                [self httpRequestForGetInfoIsComment:YES];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}
// MARK: - 收藏
/**
 收藏
 @param type 0 收藏 1 取消收藏
 */
- (void)httpRequestForCollectPostWithType:(NSString *)type {
    
    [BBSMainPresenters collectPostWithID:_postID withType:type updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                if ([type isEqualToString:@"0"]) {
                    [self showToastMsg:@"收藏成功" Duration:3.0];
                    _houseDetailModel.iscollect = @"1";
                    [_collectionButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-"] forState:UIControlStateNormal];
                }else {
                    [self showToastMsg:@"取消收藏" Duration:3.0];
                    _houseDetailModel.iscollect = @"0";
                    [_collectionButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-灰"] forState:UIControlStateNormal];
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}
/**
 收藏，私聊按钮点击
 */
- (IBAction)twoButtonsDidTouch:(UIButton *)sender {
    //1.收藏 2.私聊
    if (sender.tag == 1) {
        
        [self httpRequestForCollectPostWithType:_houseDetailModel.iscollect];
        
    }
    if (sender.tag == 2) {
        
        NSString *userid = [NSString stringWithFormat:@"%@",_houseDetailModel.userid];

        if ([XYString isBlankString:userid]) {
            [self showToastMsg:@"获得用户信息失败" Duration:3.0];
            return;
        }
        AppDelegate *appDelegate = GetAppDelegates;
        if ([userid isEqualToString:appDelegate.userData.userID]) {
            [self showToastMsg:@"不能和自己聊天" Duration:3.0];
            return;
        }
        
        ChatViewController *chatC =[[ChatViewController alloc]initWithChatType:XMMessageChatSingle];
        chatC.navigationItem.title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",_houseDetailModel.nickname]];
        chatC.ReceiveID = userid;
        
        if (_contentDictionary) {
            chatC.isGoods = YES;
            chatC.goodsDic = _contentDictionary;
        }
        
        [self.navigationController pushViewController:chatC animated:YES];

    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [_textView resignFirstResponder];

    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":LinQu_TieZi,@"postid":_postID}];
    
    [_textView resignFirstResponder];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [_textView resignFirstResponder];

    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:LinQu];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    isFirstInVC = YES;

    if (_bbsModel.housetype.integerValue == 10 || _bbsModel.housetype.integerValue == 11) {
        self.navigationItem.title = @"房产帖详情";
    }else if (_bbsModel.housetype.integerValue == 30 || _bbsModel.housetype.integerValue == 31){
        self.navigationItem.title = @"车位帖详情";
    }else {
        self.navigationItem.title = @"";
    }
    
    if (kDevice_Is_iPhoneX) {
        _TFBgViewBottomConstraint.constant = bottomSafeArea_Height;
    }
    
    _textView.layer.cornerRadius = 10;
    _textView.clipsToBounds = YES;
    _textView.delegate = self;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = TEXT_COLOR.CGColor;
    
    [self setupPlaceHolder];
    
    _contentDictionary = [[NSDictionary alloc] init];
    
//    _houseDetailModel = [[L_HouseDetailModel alloc] init];
    
    _commentArray = [[NSMutableArray alloc] init];
    
//    _tableView.alpha = 0;

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseImageTVC" bundle:nil] forCellReuseIdentifier:@"L_HouseImageTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailsFirstTVC" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailsFirstTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailSecondTVC" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailSecondTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailThirdTVC" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailThirdTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailForthTVC" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailForthTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailCommentTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailCommentTVC"];

    @WeakObj(self)
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetInfoIsComment:NO];
    }];

    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForCommentListIsRefresh:NO isComment:NO];
    }];
    
    [_tableView.mj_header beginRefreshing];

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"邻圈_群_群设置_举报-退出"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightNavBarButton;
    
    [self setupRedInfo];/** 设置红包位置信息 */
}
// MARK: - 设置红包位置信息
- (void)setupRedInfo {
    
    _redButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _redButton.frame = CGRectMake(SCREEN_WIDTH - 50 - 10, 10, 50, 100);
    [_redButton setBackgroundImage:[UIImage imageNamed:@"商品帖-商品详情-悬浮红包"] forState:UIControlStateNormal];
    _redButton.hidden = YES;
    [self.view addSubview:_redButton];
    [self.view bringSubviewToFront:_redButton];
 
    [_redButton addTarget:self action:@selector(redButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)redButtonDidTouch:(UIButton *)button {
    NSLog(@"点击红包");
    
    if ([XYString isBlankString:_houseDetailModel.redid]) {
        
        return;
    }else{
        
       [self httpRequestForGetRedStateWithRedid:_houseDetailModel.redid];
    }
}


#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //    if (self.picking) return;
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y >= self.view.height_sd) { // 键盘的Y值已经远远超过了控制器view的高度
            _TFBgViewBottomConstraint.constant = 0;
            if (kDevice_Is_iPhoneX) {
                _TFBgViewBottomConstraint.constant = bottomSafeArea_Height;
            }

        }else {
            _TFBgViewBottomConstraint.constant = keyboardF.size.height;

        }
        
        
    }];
    
}
- (void)textViewDidChange:(UITextView *)textView {
    
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    
    [self limitWordCountsWithTextView:textView];
    
    if (!_currentTextViewContentSize.width) {
        _currentTextViewContentSize = textView.contentSize;
    } else {
        if (_currentTextViewContentSize.height < textView.contentSize.height) {
            [self updateHeight:textView isInput:YES];
        } else if (_currentTextViewContentSize.height > textView.contentSize.height) {
            [self updateHeight:textView isInput:NO];
        }
    }
    


}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    
    [self limitWordCountsWithTextView:textView];

}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        placeHolder.alpha = 1;
    } else {
        placeHolder.alpha = 0;
    }
    
    [self limitWordCountsWithTextView:textView];

}
- (void)updateHeight:(UITextView *)textView isInput:(BOOL)isInput {
    isInput ? ++_textLine : --_textLine;
    
    _currentTextViewContentSize = textView.contentSize;
    CGFloat height = kHouseCommentInputViewHeight + _textLine * kHouseCommentInputTextViewHeight;
    
    if (height >= 84) {
        height = 84;
    }else {
        height = 50;
    }
    [UIView animateWithDuration:0.25f animations:^{
        _TFBgViewHeightConstraint.constant = height;
        
    }];
}
// MARK: - 限制字数
/**
 限制字数
 */
- (void)limitWordCountsWithTextView:(UITextView *)textView {
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > HouseMAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:HouseMAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    //    textView.text = [NSString stringWithFormat:@"%ld/%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum),(long)MAX_LIMIT_NUMS];
    
    
}
// MARK: - 给textView添加一个UILabel子控件
- (void)setupPlaceHolder {
    placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 60, 21)];
    placeHolder.text = @"评论";
    placeHolder.textColor = TEXT_COLOR;
    placeHolder.numberOfLines = 1;
    placeHolder.font = DEFAULT_FONT(14);
    [self.textView addSubview:placeHolder];
}
// MARK: - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送");
        [textView endEditing:YES];
        
        [self httpRequestForAddCommentWithContent:textView.text];
        
        return NO;
        
    }else {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //获取高亮部分内容
        //NSString * selectedtext = [textView textInRange:selectedRange];
        
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            
            if (offsetRange.location < HouseMAX_LIMIT_NUMS) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = HouseMAX_LIMIT_NUMS - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = @"";
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                }
                else
                {
                    __block NSInteger idx = 0;
                    __block NSString  *trimString = @"";//截取出的字串
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                              
                                              if (idx >= rg.length) {
                                                  *stop = YES; //取出所需要就break，提高效率
                                                  return ;
                                              }
                                              
                                              trimString = [trimString stringByAppendingString:substring];
                                              
                                              idx++;
                                          }];
                    
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
                //既然是超出部分截取了，哪一定是最大限制了。
                //                textView.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            }
            return NO;
        }

    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + _commentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 3;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= 1) {
        return 8;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = CLEARCOLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat height = SCREEN_WIDTH / 640 * 370;
            
            return height;
        }else {
            return 90;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return _houseDetailModel.firstHeight;
        }else if (indexPath.row == 1) {
            return _houseDetailModel.secondHeight;
        }else {
            return 50;
        }
    }else {
        L_TieziCommentModel *model = _commentArray[indexPath.section - 2];
        return model.height;
    }

}
#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return PLACEHOLDER_IMAGE;
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    if (_houseDetailModel.piclist.count > 0) {
        
        NSDictionary *dict = _houseDetailModel.piclist[index];
        return [NSURL URLWithString:dict[@"picurl"]];
        
    }else {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"车位默认图片.png" withExtension:nil];
        return url;
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 0) {
            L_HouseImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseImageTVC"];
            
            if (_houseDetailModel) {
                cell.model = _houseDetailModel;
            }
            
            cell.imageDidBlock = ^(NSInteger index) {
              
                [_textView resignFirstResponder];

                SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
                browser.sourceImagesContainerView = self.view;
                if (_houseDetailModel.piclist.count > 0 ) {
                    browser.imageCount = _houseDetailModel.piclist.count;
                }else {
                    browser.imageCount = 1;
                }
                browser.currentImageIndex = index;
                browser.delegate = self;
                [browser show]; // 展示图片浏览器
                
            };
            
            return cell;
            
        }else {
            
            L_HouseDetailsFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailsFirstTVC"];
            
            if (_houseDetailModel) {
                cell.model = _houseDetailModel;
            }
            return cell;
        }

    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            L_HouseDetailSecondTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailSecondTVC"];
            
            if (_houseDetailModel) {
                cell.model = _houseDetailModel;
            }
            return cell;
            
        }else if (indexPath.row == 1) {
            
            L_HouseDetailThirdTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailThirdTVC"];
            
            if (_houseDetailModel) {
                cell.model = _houseDetailModel;
            }
            return cell;
            
        }else {
            
            L_HouseDetailForthTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailForthTVC"];
            
            if (_houseDetailModel) {
                cell.model = _houseDetailModel;
            }
            cell.praiseButtonDidBlock = ^(){
              
                [self httpRequestForPraiseType:_houseDetailModel.ispraise.integerValue withPostid:_postID];

            };
            
            cell.headerButtonDidBlock = ^(NSString *userID) {
                
                if (userID == nil) {
                    //点赞列表
                    NSString *personNum = [NSString stringWithFormat:@"%lu",(unsigned long)_houseDetailModel.praiselist.count];
                    
                    if ([XYString isBlankString:_postID] || [XYString isBlankString:personNum] || personNum.integerValue <= 0) {
                        return;
                    }
                    
                    PraiseListVC * plVC = [[PraiseListVC alloc]init];
                    plVC.postid =  _postID;
                    plVC.praisecount = personNum;
                    [self.navigationController pushViewController:plVC animated:YES];
                    
                }else {
                    
                    //点赞头像点击
                    NSLog(@"userid==%@",userID);
                    personListViewController *personList = [[personListViewController alloc]init];
                    [personList getuserID:userID];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:personList animated:YES];
                }
                

            };
            
            return cell;
            
        }
        
    }else {
        
        L_NormalDetailCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailCommentTVC"];
        
        if (_commentArray.count > 0 ) {
            
            L_TieziCommentModel *model = _commentArray[indexPath.section - 2];
            
            cell.model = model;
            
            cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex){
                //1.头像 2.评论列表
                if (buttonIndex == 1) {
                    
                    personListViewController *personList = [[personListViewController alloc]init];
                    [personList getuserID:model.userid];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:personList animated:YES];
                    
                }
                if (buttonIndex == 2) {
                    
//                    AppDelegate *appDlgt = GetAppDelegates;
//                    if ([model.userid isEqualToString:appDlgt.userData.userID]) {
//                        [self showToastMsg:@"您自己不能回复自己哦!" Duration:3.0];
//                        return ;
//                    }
                    
                    L_CommentListViewController *commentListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_CommentListViewController"];
                    commentListVC.postID = _postID;
                    commentListVC.commentID = model.theID;
                    commentListVC.commentNickName = model.nickname;
                    
                    commentListVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
                        
                        if (![XYString isBlankString:comment]) {
                            
                            model.commentcount = comment;
                        }
                        
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                    };
                    
                    [self.navigationController pushViewController:commentListVC animated:YES];
                    
                }
                
            };
            
        }
        
        return cell;
        
    }
    

}

- (void)rightBarButtonAction {
    
    NSString *userID = _houseDetailModel.userid;
    NSString *postID = _postID;
    
    if ([XYString isBlankString:userID] || [XYString isBlankString:postID]) {
        return;
    }
    
    AppDelegate * appDlgt = GetAppDelegates;
    if ([appDlgt.userData.userID isEqualToString:userID]) {
        
        MMPopupItemHandler block = ^(NSInteger index){
            NSLog(@"clickd %@ button",@(index));
            
            switch (index) {
                case 0:
                {
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.sourceid            = _postID;
                    SCML.shareTitle          = _houseDetailModel.title;
                    if (_houseDetailModel.piclist.count > 0) {
                        SCML.shareImg            = _houseDetailModel.piclist[0][@"picurl"];
                    }else {
                        SCML.shareImg            = SHARE_LOGO_IMAGE;
                    }
                    SCML.shareContext        = _houseDetailModel.content;
                    SCML.shareUrl            = [NSString stringWithFormat:@"%@%@%@",SERVER_URL_New,kShareHouseOrCarDetailUrl,_postID];
                    SCML.type                = 4;
                    SCML.shareSuperView      = self.view;
                    SCML.shareType           = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];
                    
                }
                    break;
                case 1:
                {
                    /** 判断是否是自己的帖子 */
                    if([appDlgt.userData.userID isEqualToString:userID]) {
                        
                        [[ActionSheetVC shareActionSheet] dismiss];
                        
                        [[MessageAlert shareMessageAlert] showInVC:self withTitle:@"确定删除此条帖子吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
                        [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                NSLog(@"---点击删除");
                                
                                [self httpRequestForDeleteWithPostid:postID];
                                
                            }
                        };
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        };
        
        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
            NSLog(@"animation complete");
        };
        
        NSArray *items =
        @[MMItemMake(@"分享", MMItemTypeNormal, block),
          MMItemMake(@"删除", MMItemTypeNormal, block)];
        
        [[[MMSheetView alloc] initWithTitle:@""
                                      items:items] showWithBlock:completeBlock];
        
    }else {
        
        MMPopupItemHandler block = ^(NSInteger index){
            NSLog(@"clickd %@ button",@(index));
            
            switch (index) {
                case 0:
                {
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.sourceid            = _postID;
                    SCML.shareTitle          = _houseDetailModel.title;
                    if (_houseDetailModel.piclist.count > 0) {
                        SCML.shareImg            = _houseDetailModel.piclist[0][@"picurl"];
                    }else {
                        SCML.shareImg            = SHARE_LOGO_IMAGE;
                    }
                    SCML.shareContext        = _houseDetailModel.content;
                    SCML.shareUrl            = [NSString stringWithFormat:@"%@%@%@",SERVER_URL_New,kShareHouseOrCarDetailUrl,_postID];
                    SCML.type                = 4;
                    SCML.shareSuperView      = self.view;
                    SCML.shareType           = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];
                    
                }
                    break;
                case 1:
                {
                    if (![XYString isBlankString:userID]) {
                        
                        MMPopupItemHandler block = ^(NSInteger index){
                            NSLog(@"clickd %@ button",@(index));
                            
                            [PostPresenter addPostsReport:postID withType:[NSString stringWithFormat:@"%ld",index] andSource:@"1" andCallBack:^(id  _Nullable data, ResultCode resultCode) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if(resultCode == SucceedCode) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self showToastMsg:@"举报成功" Duration:3.0];
                                            
                                        });
                                        
                                    }else {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            if ([XYString isBlankString:data]) {
                                                [self showToastMsg:@"举报失败" Duration:3.0];
                                            }else {
                                                [self showToastMsg:data Duration:3.0];
                                            }
                                            
                                        });
                                        
                                    }
                                    
                                });
                                
                            }];
                            
                        };
                        
                        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
                            NSLog(@"animation complete");
                        };
                        
                        NSArray *items =
                        @[MMItemMake(@"骚扰信息", MMItemTypeNormal, block),
                          MMItemMake(@"虚假身份", MMItemTypeNormal, block),
                          MMItemMake(@"广告欺诈", MMItemTypeNormal, block),
                          MMItemMake(@"不当发言", MMItemTypeNormal, block),];
                        
                        [[[MMSheetView alloc] initWithTitle:@""
                                                      items:items] showWithBlock:completeBlock];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        };
        
        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
            NSLog(@"animation complete");
        };
        
        NSArray *items =
        @[MMItemMake(@"分享", MMItemTypeNormal, block),
          MMItemMake(@"举报", MMItemTypeNormal, block)];
        
        [[[MMSheetView alloc] initWithTitle:@""
                                      items:items] showWithBlock:completeBlock];
    }
    
    
}

// MARK: - 跳转红包领取详情
/**
 跳转红包领取详情
 */
- (void)gotoRedInfoVC {
    
    NSString *redID = _houseDetailModel.redid;
    if ([XYString isBlankString:redID]) {
        [self showToastMsg:@"获取红包信息失败" Duration:3.0];
        return;
    }
    
    RedPacketsVC * rpVC = [[RedPacketsVC alloc]init];
    rpVC.redid = redID;
    [self.navigationController pushViewController:rpVC animated:YES];
}

@end
