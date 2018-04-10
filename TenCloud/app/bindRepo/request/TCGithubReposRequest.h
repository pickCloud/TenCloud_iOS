//
//  TCGithubReposRequest.h
//  功能:绑定仓库页面，获取github仓库列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCApp;
@class TCAppRepo;
@interface TCGithubReposRequest : YTKRequest

@property (nonatomic, strong)   NSString    *url;

- (NSArray<TCAppRepo*> *)resultRepoArray;

- (void) startWithSuccess:(void(^)(NSArray<TCAppRepo*> *repoArray))success
                  failure:(void(^)(NSString *message))failure;

@end
