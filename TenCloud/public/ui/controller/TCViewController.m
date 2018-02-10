//
//  TCViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCViewController.h"


@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEME_BACKGROUND_COLOR;
    
    if (self.navigationController.viewControllers.count > 1) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchDown];
        UIImage *nomalImage = [UIImage imageNamed:@"public_back"];
        [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        //[button sizeToFit];
        button.bounds = CGRectMake(0, 0, 44, 44);
        
        CGFloat btnOffset = TCSCALE(18)+TCSCALE(18);//0;//TCSCALE(18);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -btnOffset, 0, 0);
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        //CGRect btnRect = button.frame;
        //NSLog(@"back btn rect:%.2f, %.2f, %.2f, %.2f",btnRect.origin.x, btnRect.origin.y, btnRect.size.width, btnRect.size.height);
        
        /*
         //deprecated
        if (button.bounds.size.width < 40) {
            CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
            button.bounds = CGRectMake(0, 0, width, 40);
        }
        if (button.bounds.size.height > 40) {
            CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
            button.bounds = CGRectMake(0, 0, 40, height);
        }
        
        button.imageEdgeInsets = UIEdgeInsetsZero;
         */
        
        

        
        /*
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor =
        [UIColor colorWithRed:0.99 green:0.50 blue:0.09 alpha:1.00];
        //主要是以下两个图片设置
        self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"public_back"];
        //self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"public_back"];
        self.navigationItem.backBarButtonItem = backItem;
        */
        
        /*
        //deprecated
        UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedButton.width = -15;
        //self.navigationItem.leftBarButtonItems = @[fixedButton, backButtonItem];
        //self.navigationItem.leftBarButtonItems = @[backButtonItem, fixedButton];
        */
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
