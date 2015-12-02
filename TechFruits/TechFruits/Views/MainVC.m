//
//  MainVC.m
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import "MainVC.h"
#import "AMRatingControl.h"
#import "FruitsDetaitVC.h"
#import "FruitsDetail.h"
#import "Fruits.h"
#import "ImageSaver.h"

@interface MainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *fruits;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Fruits";
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
//    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.tableFooterView = [UIView new];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 24);
    [button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewFruitVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] init];
    [addItem setCustomView:button];
    
    self.navigationItem.rightBarButtonItem = addItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fruits = [[Fruits findAllSortedBy:@"name" ascending:YES] mutableCopy];
    
    [self.mainTableView reloadData];
}

-(void)deleteAllEntites{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObject = [app managedObjectContext];
    
    for (Fruits *fruitToDelete in self.fruits) {
        [managedObject deleteObject:fruitToDelete];
    }
}

-(void)addNewFruitVC{
    FruitsDetaitVC *newVC = [FruitsDetaitVC new];
    [self addNavigationButton:newVC];
    [self.navigationController pushViewController:newVC animated:YES];
}

-(void)addNavigationButton:(FruitsDetaitVC*)upcoming{
    upcoming.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:upcoming action:@selector(cancelAdd)];
    upcoming.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:upcoming action:@selector(addNewFruit)];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fruits.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellStyleValue1;
    
    Fruits *item = self.fruits[indexPath.row];
    
    cell.textLabel.text = item.name;
    
    //setup AMRatingControl
    AMRatingControl *ratingControl;
    if (![cell viewWithTag:102]) {
        ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(220, 10)
                                                       emptyImage:[[UIImage imageNamed:@"star-empty"] convertToSize:CGSizeMake(20, 20)]
                                                       solidImage:[[UIImage imageNamed:@"star-full"] convertToSize:CGSizeMake(20, 20)]
                                                     andMaxRating:5];
        ratingControl.tag = 102;
        ratingControl.userInteractionEnabled = NO;
    }else{
        ratingControl = (AMRatingControl*)[cell viewWithTag:102];
    }
    
    ratingControl.rating = [item.fruitsDetail.rating integerValue];
    [cell addSubview:ratingControl];
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Fruits *item = self.fruits[indexPath.row];
    FruitsDetaitVC *detail = [FruitsDetaitVC new];
    detail.fruit = item;
    [self addNavigationButton:detail];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Fruits *fruitToRemove = self.fruits[indexPath.row];
        
        //remove image from document folder of app
        if (fruitToRemove.fruitsDetail.image) {
            [ImageSaver deleteImageAtPath:fruitToRemove.fruitsDetail.image];
        }
        
        //remove entity using MagicalRecord
        [fruitToRemove deleteEntity];
        [self saveContext];
        [self.fruits removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - handle
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
