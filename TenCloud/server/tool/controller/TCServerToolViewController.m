//
//  TCServerOperateViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/12.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerToolViewController.h"
#import "TCServerStatusManager.h"
#import "TCStopServerRequest.h"
#import "TCRebootServerRequest.h"
#import "TCStartServerRequest.h"
#import "TCAlertController.h"

@interface TCServerToolViewController ()<TCServerStatusDelegate>
@property (nonatomic, strong)   UIVisualEffectView      *effectView;
@property (nonatomic, assign)   NSInteger               serverID;
@property (nonatomic, strong)   NSString                *status;
@property (nonatomic, weak) IBOutlet    UIButton        *stopButton;
@property (nonatomic, weak) IBOutlet    UIButton        *restartButton;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onStopButton:(id)sender;
- (IBAction) onRestartButton:(id)sender;
- (IBAction) onRemoteAccessButton:(id)sender;
- (IBAction) onProcessStatusButton:(id)sender;
- (IBAction) onNetworkStatusButton:(id)sender;
- (IBAction) onRouteInfoButton:(id)sender;
- (IBAction) onPortInfoButton:(id)sender;
- (IBAction) onConfigManageButton:(id)sender;
- (IBAction) onMonitorFileButton:(id)sender;
- (void) updateUIWithStatus:(NSString*)status completed:(BOOL)completed;
@end

@implementation TCServerToolViewController

- (instancetype) initWithServerID:(NSInteger)serverID status:(NSString*)status
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        _status = status;
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _effectView = [[UIVisualEffectView alloc] init];
    CGRect viewFrame = [[UIScreen mainScreen] bounds];
    _effectView.frame = viewFrame;
    _effectView.alpha = 0.72;
    [self.view addSubview:_effectView];
    [self.view sendSubviewToBack:_effectView];
    [[TCServerStatusManager shared] addObserver:self withServerID:_serverID];
    
    BOOL completed = [[TCServerStatusManager shared] operationCompletedWithServerID:_serverID];
    [self updateUIWithStatus:_status completed:completed];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak __typeof(self) weakSelf = self;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView.effect = nil;
    [UIView animateWithDuration:1.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.effectView.effect = blur;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[TCServerStatusManager shared] removeObserver:self withServerID:_serverID];
}

#pragma mark - extension
- (IBAction) onCloseButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.72
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakSelf dismissViewControllerAnimated:NO completion:nil];
                     }];
    
}

- (IBAction) onStopButton:(id)sender
{
    NSLog(@"on stop button");
    __weak __typeof(self) weakSelf = self;
    NSString *btnName = _stopButton.titleLabel.text;
    if ([btnName isEqualToString:@"开机"])
    {
        NSLog(@"开机啦");
        /*
        [[TCServerStatusManager shared] startWithServerID:_serverID];
         */
        TCStartServerRequest *request = [[TCStartServerRequest alloc] initWithServerID:_serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf.stopButton setEnabled:NO];
            [weakSelf.restartButton setEnabled:NO];
            [[TCServerStatusManager shared] startWithServerID:weakSelf.serverID];
        } failure:^(NSString *message) {
            
        }];
    }else
    {
        /*
        NSLog(@"关机啦");
        [[TCServerStatusManager shared] stopWithServerID:_serverID];
         */
        NSString *title = @"确定关闭这台服务器?";
        TCConfirmBlock block = ^(TCConfirmView *view){
            TCStopServerRequest *request = [[TCStopServerRequest alloc] initWithServerID:_serverID];
            [request startWithSuccess:^(NSString *status) {
                [weakSelf.stopButton setEnabled:NO];
                [weakSelf.restartButton setEnabled:NO];
                [[TCServerStatusManager shared] stopWithServerID:weakSelf.serverID];
            } failure:^(NSString *message) {
                [MBProgressHUD showError:message toView:nil];
            }];
        };
        [TCAlertController presentFromController:self
                                           title:title
                               confirmButtonName:@"关机"
                                    confirmBlock:block
                                     cancelBlock:nil];
    }
}

- (IBAction) onRestartButton:(id)sender
{
    NSLog(@"on restart button");
    //[[TCServerStatusManager shared] rebootWithServerID:_serverID];
    __weak __typeof(self) weakSelf = self;
    NSString *tip = @"确定重启这台服务器?";
    TCConfirmBlock block = ^(TCConfirmView *view){
        TCRebootServerRequest *request = [[TCRebootServerRequest alloc] initWithServerID:_serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf.stopButton setEnabled:NO];
            [weakSelf.restartButton setEnabled:NO];
            [[TCServerStatusManager shared] rebootWithServerID:weakSelf.serverID];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    };
    [TCAlertController presentFromController:self
                                       title:tip
                           confirmButtonName:@"重启"
                                confirmBlock:block
                                 cancelBlock:nil];
}

- (IBAction) onRemoteAccessButton:(id)sender
{
    
}

- (IBAction) onProcessStatusButton:(id)sender
{
    
}

- (IBAction) onNetworkStatusButton:(id)sender
{
    
}

- (IBAction) onRouteInfoButton:(id)sender
{
    
}

- (IBAction) onPortInfoButton:(id)sender
{
    
}

- (IBAction) onConfigManageButton:(id)sender
{
    
}

- (IBAction) onMonitorFileButton:(id)sender
{
    
}

- (void) updateUIWithStatus:(NSString*)status completed:(BOOL)completed
{
    if ([status isEqualToString:@"运行中"])
    {
        if (completed)
        {
            NSLog(@"已完成");
            [_stopButton setEnabled:YES];
            [_restartButton setEnabled:YES];
        }else
        {
            NSLog(@"未完成");
        }
    }else if([status isEqualToString:@"已关机"])
    {
        [_stopButton setEnabled:YES];
        [_stopButton setTitle:@"开机" forState:UIControlStateNormal];
        [_restartButton setEnabled:NO];
    }else
    {
        [_stopButton setEnabled:NO];
        [_stopButton setTitle:@"关机" forState:UIControlStateNormal];
        [_restartButton setEnabled:NO];
    }
}

#pragma mark - TCServerStatusDelegate
- (void) serverWithID:(NSInteger)serverID statusChanged:(NSString*)newStatus
            completed:(BOOL)completed
{
    NSLog(@"**** server%ld statusChanged:%@",serverID, newStatus);
    if (newStatus && newStatus.length > 0)
    {
        [self updateUIWithStatus:newStatus completed:(BOOL)completed];
    }
}

@end
