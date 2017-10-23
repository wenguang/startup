//
//  WeexViewController.m
//  demo
//
//  Created by Neeeo on 2017/3/12.
//  Copyright © 2017年 NO. All rights reserved.
//

#import "WeexViewController.h"
#import <WeexSDK/WeexSDK.h>
#import <SRWebSocket.h>

@interface WeexViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) UIView *errorView;

@end

@implementation WeexViewController

- (void)dealloc
{
    [_instance destroyInstance];
}

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if ((self = [super init])) {
        self.sourceURL = sourceURL;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationRefreshInstance:)
                                                     name:@"RefreshInstance" object:nil];
    }
    return self;
}

/**
 *  After setting the navbar hidden status , this function will be called automatically. In this function, we
 *  set the height of mainView equal to screen height, because there is something wrong with the layout of
 *  page content.
 */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ([self.navigationController isKindOfClass:[WXRootViewController class]]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}

/**
 *  We assume that the initial state of viewController's navigitonBar is hidden.  By setting the attribute of
 *  'dataRole' equal to 'navbar', the navigationBar hidden will be NO.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self addEdgePop];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _renderWithURL:_sourceURL];
}

- (void)addEdgePop
{
    UISwipeGestureRecognizer *edgePanGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}

- (UIView *)createErrorView
{
    UIImage *img = [UIImage imageNamed:@"wx_load_error"];
    UIImageView *errorView = [[UIImageView alloc] initWithImage:img];
    errorView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(errorView.bounds),
                                 CGRectGetMidY(self.view.bounds) - CGRectGetMidY(errorView.bounds),
                                 CGRectGetWidth(errorView.bounds),
                                 CGRectGetHeight(errorView.bounds));
    errorView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapErrorView)];
    [errorView addGestureRecognizer:tap];
    return errorView;
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapErrorView
{
    if (self.errorView) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    
    [self _renderWithURL:self.sourceURL];
}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.navigationController || [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _updateInstanceState:WeexInstanceAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self _updateInstanceState:WeexInstanceDisappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self _updateInstanceState:WeexInstanceMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWeex
{
    [self _renderWithURL:_sourceURL];
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    if (!sourceURL) {
        return;
    }
    
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    _instance.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    _instance.pageObject = self;
    _instance.pageName = [[WXUtility urlByDeletingParameters:sourceURL] absoluteString];
    _instance.viewController = self;
    
    NSString *newURL = nil;
    
    if ([sourceURL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newURL = [NSString stringWithFormat:@"%@&random=%d", sourceURL.absoluteString, arc4random()];
    } else {
        newURL = [NSString stringWithFormat:@"%@?random=%d", sourceURL.absoluteString, arc4random()];
    }
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf runOnMainThread:^{
            if (weakSelf.errorView) {
                [weakSelf.errorView removeFromSuperview];
                weakSelf.errorView = nil;
            }
            
            [weakSelf.weexView removeFromSuperview];
            weakSelf.weexView = view;
            [weakSelf.view addSubview:weakSelf.weexView];
        } sync:YES];
    };
    
    _instance.onFailed = ^(NSError *error) {
        [weakSelf runOnMainThread:^{
            if (weakSelf.errorView) {
                return;
            }
            weakSelf.errorView = [weakSelf createErrorView];
            [weakSelf.view addSubview:weakSelf.errorView];
        } sync:YES];
    };
    
    _instance.renderFinish = ^(UIView *view) {
        [weakSelf _updateInstanceState:WeexInstanceAppear];
    };
    
    [_instance renderWithURL:[NSURL URLWithString:newURL] options:@{@"bundleUrl":sourceURL.absoluteString} data:nil];
}

- (void)_updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == WeexInstanceAppear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        } else if (state == WeexInstanceDisappear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)runOnMainThread:(void (^)(void))block sync:(BOOL)isSync
{
    if (isSync){
        if ([NSThread isMainThread]) {
            block();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#pragma mark - notification
- (void)notificationRefreshInstance:(NSNotification *)notification {
    [self refreshWeex];
}
@end
