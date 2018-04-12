//
//  TCGithubReposRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCGithubReposRequest.h"
#import "TCAppRepo+CoreDataClass.h"

@interface TCGithubReposRequest()
@end

@implementation TCGithubReposRequest

- (void) startWithSuccess:(void(^)(NSArray<TCAppRepo*> *repoArray))success
                  failure:(void(^)(NSString *message,NSString *urlStr))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *resArray = [self resultRepoArray];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //failure ? failure([self errorMessaage]) : nil;
        NSDictionary *callbackDict = [self.responseJSONObject objectForKey:@"data"];
        if (callbackDict && [callbackDict isKindOfClass:[NSDictionary class]])
        {
            NSString *urlstr = [callbackDict objectForKey:@"url"];
            failure ? failure([self errorMessaage], urlstr) : nil;
        }else
        {
            failure ? failure([self errorMessaage], @"") : nil;
        }
    }];
}

- (NSArray<TCAppRepo*> *)resultRepoArray
{
    NSDictionary *arrayDict = [self.responseJSONObject objectForKey:@"data"];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *resArray = [TCAppRepo mj_objectArrayWithKeyValuesArray:arrayDict context:context];
    return resArray;
}

- (NSString *)requestUrl {
    //NSString *url = [NSString stringWithFormat:@"/api/repos",_status];
    //return url;
    return @"/api/repos";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    if (!_url) {
        _url = @"";
    }
    return @{@"url":_url};
}
@end
