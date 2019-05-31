//
//  L_NormalDetailsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NormalDetailsViewController.h"
//TVC
#import "L_NormalDetailsFirstTVC.h"
#import "L_NormalDetailsSecondTVC.h"
#import "L_NormalDetailImageTVC.h"
#import "L_NormalDetailThirdTVC.h"
#import "L_NormalDetailForthTVC.h"
#import "L_NormalDetailCommentTVC.h"

#import "BBSMainPresenters.h"
#import "L_NewMinePresenters.h"

#import "L_CommentListViewController.h"
#import "personListViewController.h"

#import "SharePresenter.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "PostPresenter.h"
#import "ActionSheetVC.h"
#import "MessageAlert.h"

#import "RedPacketsAlertVC.h"
#import "RedPacketsVC.h"
#import "PraiseListVC.h"

CGFloat const kCommentInputViewHeight = 50.0f;
CGFloat const kCommentInputTextViewHeight = 34.0f;

NSInteger const NormalMAX_LIMIT_NUMS = 2000;/** 评论字数限制 */

@interface L_NormalDetailsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SDPhotoBrowserDelegate>
{
    CGSize _currentTextViewContentSize;
    NSInteger _textLine;
    CGRect keyboardF;
    UILabel *placeHolder;
    BOOL isRefreshBeginning;//是否是正在刷新状态
    BOOL isFirstInVC;//第一次进入
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFBgHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (nonatomic, strong) L_NormalInfoModel *normalInfoModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 当前帖子下面显示的评论
 */
@property (nonatomic, strong) NSMutableArray *commentArray;


@property (nonatomic, assign) NSInteger page;

@end

@implementation L_NormalDetailsViewController

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

//                map	信息
//                        id	红包id
//                        state	红包状态0 进行中、 1 已领完、- 1 已过期、-2 已关闭、- 99已删除
//                        isreceive	是否领取 0 否 1 是

                NSDictionary *dict = (NSDictionary *)data;
                
                if (isFirstInVC) {
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 0) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"1",@"userpic":_normalInfoModel.userpicurl,@"nickname":_normalInfoModel.nickname,@"redid":_normalInfoModel.redid}];
                    }
                    
                }else {
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 0) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"1",@"userpic":_normalInfoModel.userpicurl,@"nickname":_normalInfoModel.nickname,@"redid":_normalInfoModel.redid}];
                        
                    }
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == 1) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"2",@"userpic":_normalInfoModel.userpicurl,@"nickname":_normalInfoModel.nickname,@"redid":_normalInfoModel.redid}];
                        
                    }
                    if ([dict[@"map"][@"isreceive"] integerValue] == 0 && [dict[@"map"][@"state"] integerValue] == -1) {
                        //弹出红包
                        [[RedPacketsAlertVC shareRedPacketsAlert] showInVC:self with:@{@"type":@"3",@"userpic":_normalInfoModel.userpicurl,@"nickname":_normalInfoModel.nickname,@"redid":_normalInfoModel.redid}];
                        
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
                    _normalInfoModel.iscollect = @"1";
                    [_collectButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-"] forState:UIControlStateNormal];
                }else {
                    [self showToastMsg:@"取消收藏" Duration:3.0];
                    _normalInfoModel.iscollect = @"0";
                    [_collectButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-灰"] forState:UIControlStateNormal];
                }
                
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
                _TFBgHeightConstraint.constant = 50;
                _tableBottomConstraint.constant = 0;
                if (kDevice_Is_iPhoneX) {
                    _tableBottomConstraint.constant = bottomSafeArea_Height;
                }
                [self showToastMsg:@"评论成功" Duration:3.0];
                
                NSString *commentCount = [NSString stringWithFormat:@"%@",data[@"map"][@"commentcount"]];
                
                if (self.praiseAndCommentCallBack) {
                    
                    self.praiseAndCommentCallBack(nil,commentCount,nil,nil);
                }
                
                [self httpRequestForGetPostDetailInfoIsComment:YES];

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
                
                NSMutableArray *praiseArray = [[NSMutableArray alloc] initWithArray:_normalInfoModel.praiselist];
                AppDelegate *appDlgt = GetAppDelegates;

                if (type == 0) {
                    _normalInfoModel.ispraise = @"1";
                    [praiseArray insertObject:@{@"userid":appDlgt.userData.userID,@"userpicurl":appDlgt.userData.userpic} atIndex:0];
                    
                }else {
                    _normalInfoModel.ispraise = @"0";
                    for (NSDictionary *praiseDict in _normalInfoModel.praiselist) {
                        if ([praiseDict[@"userid"] isEqualToString:appDlgt.userData.userID]) {
                            [praiseArray removeObject:praiseDict];
                        }
                    }
                }
                _normalInfoModel.praiselist = [praiseArray copy];
                _normalInfoModel.praisecount = [NSString stringWithFormat:@"%@",data[@"map"][@"praisecount"]];
                [self showToastMsg:data[@"errmsg"] Duration:3.0];

                if (self.praiseAndCommentCallBack) {
                    //type 0已点赞 1 未点赞
                    self.praiseAndCommentCallBack(_normalInfoModel.praisecount,nil,nil,[NSString stringWithFormat:@"%ld",(long)type]);
                    
                }
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];

                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}
// MARK: - 关注
/**
 关注
 @param userid 用户id
 @param type 0 新增 1 取消
 */
- (void)httpRequestForAddFollowWithUserid:(NSString *)userID type:(NSInteger)type {
    
    [L_NewMinePresenters addFollowWithUserid:userID type:type UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (resultCode == SucceedCode) {
                
                if (type == 0) {
                    _normalInfoModel.isuserfollow = @"1";
                    [self showToastMsg:@"关注成功" Duration:3.0];
                }else {
                    _normalInfoModel.isuserfollow = @"0";
                    [self showToastMsg:@"取消关注" Duration:3.0];
                }
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
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
                        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
// MARK: - 帖子详情
/**
 帖子详情
 */
- (void)httpRequestForGetPostDetailInfoIsComment:(BOOL)isComment {
    
    [BBSMainPresenters getPostInfoWithID:_postID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                _tableView.alpha = 1;

                _normalInfoModel = data;
                [_tableView reloadData];
                
                if (_normalInfoModel.iscollect.integerValue == 0) {
                    [_collectButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-灰"] forState:UIControlStateNormal];
                }else {
                    [_collectButton setImage:[UIImage imageNamed:@"邻趣-收藏图标-"] forState:UIControlStateNormal];
                }
                if (isFirstInVC) {
                    [self httpRequestForGetRedStateWithRedid:_normalInfoModel.redid];
                }
                
                [self httpRequestForCommentListIsRefresh:YES isComment:isComment];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}
// MARK: - 1.收藏 2.分享
- (IBAction)twoButtonsDidTouch:(UIButton *)sender {
    
    //1.收藏 2.分享
    if (sender.tag == 1) {
        
        [self httpRequestForCollectPostWithType:[NSString stringWithFormat:@"%@",_normalInfoModel.iscollect]];
    }
    if (sender.tag == 2) {
        
        //分享应用
        ShareContentModel * SCML = [[ShareContentModel alloc]init];
        SCML.sourceid            = _postID;
        SCML.shareTitle          = _normalInfoModel.title;
        if (_normalInfoModel.piclist.count > 0) {
            SCML.shareImg            = _normalInfoModel.piclist[0][@"picurl"];
        }else {
            SCML.shareImg            = SHARE_LOGO_IMAGE;
        }
        SCML.shareContext        = _normalInfoModel.content;
        SCML.shareUrl            = [NSString stringWithFormat:@"%@%@%@",SERVER_URL_New,kSharePPTReleaseDetailUrl,_postID];
        SCML.type                = 4;
        SCML.shareSuperView      = self.view;
        SCML.shareType           = SSDKContentTypeAuto;
        [SharePresenter creatShareSDKcontent:SCML];
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [_textView resignFirstResponder];
    
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":LinQu_TieZi,@"postid":_postID}];
    
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
    
    _textView.layer.cornerRadius = 10;
    _textView.clipsToBounds = YES;
    _textView.delegate = self;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = TEXT_COLOR.CGColor;
    
    [self setupPlaceHolder];
    
    if (kDevice_Is_iPhoneX) {
        _tableBottomConstraint.constant = bottomSafeArea_Height;
    }
    
//    _normalInfoModel = [[L_NormalInfoModel alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    _page = 1;

    _normalInfoModel.redtype = @"0";
    
//    _tableView.alpha = 0;
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailsFirstTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailsFirstTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailsSecondTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailsSecondTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailImageTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailImageTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailThirdTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailThirdTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailForthTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailForthTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NormalDetailCommentTVC" bundle:nil] forCellReuseIdentifier:@"L_NormalDetailCommentTVC"];

    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetPostDetailInfoIsComment:NO];
        
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
            _tableBottomConstraint.constant = 0;
            if (kDevice_Is_iPhoneX) {
                _tableBottomConstraint.constant = bottomSafeArea_Height;
            }

        }else {
            _tableBottomConstraint.constant = keyboardF.size.height;
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
    
    if (existTextNum > NormalMAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:NormalMAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    //    textView.text = [NSString stringWithFormat:@"%ld/%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum),(long)MAX_LIMIT_NUMS];

    
}

- (void)updateHeight:(UITextView *)textView isInput:(BOOL)isInput {
    isInput ? ++_textLine : --_textLine;
    
    _currentTextViewContentSize = textView.contentSize;
    CGFloat height = kCommentInputViewHeight + _textLine * kCommentInputTextViewHeight;
    
    if (height >= 84) {
        height = 84;
    }else {
        height = 50;
    }
    [UIView animateWithDuration:0.25f animations:^{
        _TFBgHeightConstraint.constant = height;
    
    }];
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
            
            if (offsetRange.location < NormalMAX_LIMIT_NUMS) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = NormalMAX_LIMIT_NUMS - comcatstr.length;
        
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
    return 4 + _commentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return _normalInfoModel.piclist.count + 1;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section > 2) {
        return 8;
    }else {
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = CLEARCOLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 65;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return _normalInfoModel.contentHeight;
        }else {
            // 先从缓存中查找图片
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: [_normalInfoModel.piclist[indexPath.row - 1] objectForKey:@"picurl"]];
            
            // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
            if (!image) {
                image = PLACEHOLDER_IMAGE;
            }
            
            //手动计算cell
            CGFloat imgHeight = image.size.height * (SCREEN_WIDTH - 16) / image.size.width;
            return imgHeight;
        }
    }else if (indexPath.section == 2 || indexPath.section == 3) {
        return 50;
    }else {
        L_TieziCommentModel *model = _commentArray[indexPath.section - 4];
        return model.height;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        L_NormalDetailsFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailsFirstTVC"];
        
        if (_normalInfoModel) {
            cell.model = _normalInfoModel;
        }
        
        cell.allButtonsDidTouchBlock = ^(NSInteger buttonIndex) {
            //1.头像点击 2.加关注点击
            if (buttonIndex == 1) {
                
                personListViewController *personList = [[personListViewController alloc]init];
                [personList getuserID:_normalInfoModel.userid];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:personList animated:YES];
                
            }
            if (buttonIndex == 2) {

                [self httpRequestForAddFollowWithUserid:_normalInfoModel.userid type:_normalInfoModel.isuserfollow.integerValue];
            }
        };
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            L_NormalDetailsSecondTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailsSecondTVC"];

            if (_normalInfoModel) {
                cell.model = _normalInfoModel;
            }
            if (_normalInfoModel.piclist.count == 0) {
                cell.lineView.hidden = YES;
            }else {
                cell.lineView.hidden = NO;
            }
            
            cell.redButtonDidTouchBlock = ^(){
              
                NSLog(@"红包点击");
                [self httpRequestForGetRedStateWithRedid:_normalInfoModel.redid];
                
            };
            
            return cell;
            
        }else {
            
            L_NormalDetailImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailImageTVC"];
            
            [self configureCell:cell atIndexPath:indexPath];

            return cell;
            
        }

    }else if (indexPath.section == 2) {

        L_NormalDetailThirdTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailThirdTVC"];
        
        if (_normalInfoModel) {
            cell.model = _normalInfoModel;
        }
        return cell;
        
    }else if (indexPath.section == 3) {
        
        L_NormalDetailForthTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailForthTVC"];
        
        if (_normalInfoModel) {
            cell.model = _normalInfoModel;
        }
        
        cell.praiseButtonDidBlock = ^(){
          //点赞
            [self httpRequestForPraiseType:_normalInfoModel.ispraise.integerValue withPostid:_postID];
            
        };
        
        cell.headerButtonDidBlock = ^(NSString *userid) {
            
            if (userid == nil) {
                //点赞列表
                NSString *personNum = [NSString stringWithFormat:@"%lu",(unsigned long)_normalInfoModel.praiselist.count];
    
                if ([XYString isBlankString:_postID] || [XYString isBlankString:personNum] || personNum.integerValue <= 0) {
                    return;
                }
    
                PraiseListVC * plVC = [[PraiseListVC alloc]init];
                plVC.postid =  _postID;
                plVC.praisecount = personNum;
                [self.navigationController pushViewController:plVC animated:YES];
                
            }else {
                
                //点赞头像点击
                NSLog(@"userid==%@",userid);
                personListViewController *personList = [[personListViewController alloc]init];
                [personList getuserID:userid];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:personList animated:YES];
            }
            


        };
        
        return cell;
        
    }else {
        
        L_NormalDetailCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NormalDetailCommentTVC"];
        
        if (_commentArray.count > 0 ) {
            
            L_TieziCommentModel *model = _commentArray[indexPath.section - 4];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if (indexPath.row > 0) {
            
            [_textView resignFirstResponder];
            
            SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
            browser.sourceImagesContainerView = self.view;
            browser.imageCount = _normalInfoModel.piclist.count;
            browser.currentImageIndex = indexPath.row - 1;
            browser.delegate = self;
            [browser show]; // 展示图片浏览器
        }
        
    }
    
}
#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    L_NormalDetailImageTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:1]];
    
    return cell.detailImageView.image;
}
//返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    NSDictionary *dict = _normalInfoModel.piclist[index];
    return [NSURL URLWithString:dict[@"picurl"]];
    
}

- (void)configureCell:(L_NormalDetailImageTVC *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imgURL = [_normalInfoModel.piclist[indexPath.row - 1] objectForKey:@"picurl"];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    if ( !cachedImage ) {
        [self downloadImage:[_normalInfoModel.piclist[indexPath.row - 1] objectForKey:@"picurl"] forIndexPath:indexPath];
        [cell.detailImageView setImage:PLACEHOLDER_IMAGE];
    } else {
        [cell.detailImageView setImage:cachedImage];
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            //[[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES completion:nil];
        }else {
            //[[SDImageCache sharedImageCache] storeImage:PLACEHOLDER_IMAGE forKey:imageURL toDisk:YES];
            [[SDImageCache sharedImageCache] storeImage:PLACEHOLDER_IMAGE forKey:imageURL toDisk:YES completion:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)rightBarButtonAction {
    
    NSString *userID = _normalInfoModel.userid;
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
                    SCML.shareTitle          = _normalInfoModel.title;
                    if (_normalInfoModel.piclist.count > 0) {
                        SCML.shareImg            = _normalInfoModel.piclist[0][@"picurl"];
                    }else {
                        SCML.shareImg            = SHARE_LOGO_IMAGE;
                    }
                    SCML.shareContext        = _normalInfoModel.content;
                    SCML.shareUrl            = [NSString stringWithFormat:@"%@%@%@",SERVER_URL_New,kSharePPTReleaseDetailUrl,_postID];
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
                    SCML.shareTitle          = _normalInfoModel.title;
                    if (_normalInfoModel.piclist.count > 0) {
                        SCML.shareImg            = _normalInfoModel.piclist[0][@"picurl"];
                    }else {
                        SCML.shareImg            = SHARE_LOGO_IMAGE;
                    }
                    SCML.shareContext        = _normalInfoModel.content;
                    SCML.shareUrl            = [NSString stringWithFormat:@"%@%@%@",SERVER_URL_New,kSharePPTReleaseDetailUrl,_postID];
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
                                        
                                    }
                                    else {
                                        
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

    NSString *redID = _normalInfoModel.redid;
    if ([XYString isBlankString:redID]) {
        [self showToastMsg:@"获取红包信息失败" Duration:3.0];
        return;
    }
    
    RedPacketsVC * rpVC = [[RedPacketsVC alloc]init];
    rpVC.redid = redID;
    [self.navigationController pushViewController:rpVC animated:YES];
}

@end
