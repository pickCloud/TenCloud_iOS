//
//  TCAddAppRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddAppRequest.h"

@interface TCAddAppRequest()
@end

@implementation TCAddAppRequest

- (void) startWithSuccess:(void(^)(NSInteger corpID))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSNumber *appIDNum = [dataDict objectForKey:@"id"];
            success ? success (appIDNum.integerValue) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/application/new";
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
    
    return @{@"name":_name,
             @"description":_desc,
             @"repos_name":_repos_name,
             @"repos_ssh_url":_repos_ssh_url,
             @"repos_https_url":_repos_https_url,
             @"logo_url":_logo_url,
             @"image_id":_image_id
             };
}

@end
