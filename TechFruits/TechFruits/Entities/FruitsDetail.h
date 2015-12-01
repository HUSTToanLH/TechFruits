//
//  FruitsDetail.h
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fruits;

@interface FruitsDetail : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Fruits *fruits;

@end
