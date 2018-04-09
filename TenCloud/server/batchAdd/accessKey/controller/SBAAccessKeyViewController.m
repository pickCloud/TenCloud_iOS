//
//  SBAAccessKeyViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/4/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBAAccessKeyViewController.h"
#import "SBASelectServerViewController.h"

@interface SBAAccessKeyViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)   UIButton                *nextButton;
@property (nonatomic, weak) IBOutlet    UITextField     *idField;
@property (nonatomic, weak) IBOutlet    UITextField     *secretField;
- (void) onNextButton:(UIButton*)button;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onHelpButton:(id)sender;
- (IBAction) onHowToForbiddenButton:(id)sender;
@end

@implementation SBAAccessKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"批量添加云主机";
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(onNextButton:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = TCFont(16);
    [_nextButton sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_nextButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - extension
- (void) onNextButton:(UIButton*)button
{
    SBASelectServerViewController *selectVC = [SBASelectServerViewController new];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void) onTapBlankArea:(id)sender
{
    NSLog(@"on tap blank area");
    [_idField resignFirstResponder];
    [_secretField resignFirstResponder];
}

- (IBAction) onHelpButton:(id)sender
{
    NSLog(@"on help button");
}

- (IBAction) onHowToForbiddenButton:(id)sender
{
    NSLog(@"on how to forbidden button");
}

@end
