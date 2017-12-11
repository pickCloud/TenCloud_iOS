//
//  TCServer+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCServerCPU;
@class TCServerNet;
@class TCServerDisk;
@class TCServerMemory;
@interface TCServer (CoreDataProperties)

+ (NSFetchRequest<TCServer *> *)fetchRequest;

@property (nullable, nonatomic, retain) TCServerNet *net_content;
@property (nullable, nonatomic, copy) NSString *machine_status;
@property (nullable, nonatomic, retain) TCServerCPU *cpu_content;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *public_ip;
@property (nullable, nonatomic, copy) NSString *instance_name;
@property (nonatomic) int64_t report_time;
@property (nullable, nonatomic, copy) NSString *provider;
@property (nullable, nonatomic, retain) TCServerDisk *disk_content;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) TCServerMemory *memory_content;
@property (nonatomic) int64_t serverID;

@end

NS_ASSUME_NONNULL_END
