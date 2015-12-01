//
//  Fruits.h
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FruitsDetail;

@interface Fruits : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) FruitsDetail *fruitsDetail;

@end
