//
//  TCDeleteTemplateRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCDeleteTemplateRequest.h"

@interface TCDeleteTemplateRequest()
@property (nonatomic, assign)   NSInteger   templateID;
@end

@implementation TCDeleteTemplateRequest

- (instancetype) initWithTemplateID:(NSInteger)tid
{
    self = [super init];
    if (self)
    {
        _templateID = tid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"删除成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    //return @"/api/user/password/set";
    NSString *url = [NSString stringWithFormat:@"/api/permission/template/%ld/del",_templateID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSInteger cid = [[TCCurrentCorp shared] cid];
    return @{@"pt_id":@(_templateID),
             @"cid":@(cid)
             };
}

@end
