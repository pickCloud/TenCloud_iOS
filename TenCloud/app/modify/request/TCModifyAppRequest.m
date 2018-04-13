//
//  TCModifyAppRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyAppRequest.h"

@interface TCModifyAppRequest()
@end

@implementation TCModifyAppRequest

- (id) init
{
    self = [super init];
    if (self)
    {
        _labels = [NSMutableArray new];
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSInteger corpID))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        /*
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSNumber *appIDNum = [dataDict objectForKey:@"id"];
            success ? success (appIDNum.integerValue) : nil;
        }
         */
        success ? success(0) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/application/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    if (!_repos_ssh_url) {
        _repos_ssh_url = @"";
    }
    if (!_repos_https_url) {
        _repos_https_url = @"";
    }
    
    return @{@"id":@(_appID),
             @"name":_name,
             @"description":_desc,
             @"repos_name":_repos_name,
             @"repos_ssh_url":_repos_ssh_url,
             @"repos_https_url":_repos_https_url,
             @"logo_url":_logo_url,
             @"image_id":_image_id,
             @"labels":_labels
             };
}

@end
