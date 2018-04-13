//
//  TCModifyAppRequest.h
//  功能:修改应用网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCModifyAppRequest : YTKRequest

@property (nonatomic, assign)   NSInteger   appID;
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *desc;
@property (nonatomic, strong)   NSString    *repos_name;
@property (nonatomic, strong)   NSString    *repos_ssh_url;
@property (nonatomic, strong)   NSString    *repos_https_url;
@property (nonatomic, strong)   NSString    *logo_url;
@property (nonatomic, strong)   NSNumber    *image_id;
@property (nonatomic, strong)   NSMutableArray  *labels;

- (void) startWithSuccess:(void(^)(NSInteger appID))success
                  failure:(void(^)(NSString *message))failure;

@end
