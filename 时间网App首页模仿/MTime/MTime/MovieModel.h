//
//  MovieModel.h
//  MTime
//
//  Created by YangJingchao on 16/2/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject
@property (nonatomic, strong) NSString * cat;
@property (nonatomic, strong) NSString * dir;
@property (nonatomic, assign) NSInteger dur;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * nm;
@property (nonatomic, strong) NSString * rt;
@property (nonatomic, strong) NSString * sc;
@property (nonatomic, strong) NSString * scm;
@property (nonatomic, strong) NSArray * shows;
@property (nonatomic, strong) NSString * src;
@property (nonatomic, strong) NSString * star;
@property (nonatomic, strong) NSString * ver;
@property (nonatomic, assign) NSInteger wish;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
