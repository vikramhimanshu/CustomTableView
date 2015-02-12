//
//  GDTableViewCellInternal.h
//  CustomTableView
//
//  Created by Himanshu on 2/10/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GDTableViewCell;

@interface GDTableViewCellInternal : NSObject

@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat height;
@property (nonatomic, strong) GDTableViewCell *cachedCell;

@end
