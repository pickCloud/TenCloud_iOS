//
//  TCRenameTemplateRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRenameTemplateRequest.h"

@interface TCRenameTemplateRequest()
@property (nonatomic, assign)   NSInteger   templateID;
@property (nonatomic, strong)   NSString    *name;
@end

@implementation TCRenameTemplateRequest

- (instancetype) initWithTemplateID:(NSInteger)tid name:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _templateID = tid;
        _name = name;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/permission/template/%ld/rename",_templateID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSInteger cid = [[TCCurrentCorp shared] cid];
    return @{@"pt_id":@(_templateID),
             @"cid":@(cid),
             @"name":_name
             };
}

@end
