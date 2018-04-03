//
//  TCAppBindRepoViewController.h
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"

@class TCGitRepo;
typedef void (^TCBindRepoBlock)(TCGitRepo *repo);

@interface TCAppBindRepoViewController : TCViewController

@property (nonatomic, copy) TCBindRepoBlock     bindBlock;

@end
