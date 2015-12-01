//
//  MainVC.m
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import "MainVC.h"
#import "FruitsDetaitVC.h"
#import "Fruits.h"

@interface MainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *fruits;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Fruits";
    
    self.fruits = [[Fruits findAll] mutableCopy];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 24);
    [button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewFruit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] init];
    [addItem setCustomView:button];
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FruitsDetaitVC *upcoming = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"editFruit"]) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
        Fruits *fruit = self.fruits[indexPath.row];
        upcoming.fruit = fruit;
    } else if ([segue.identifier isEqualToString:@"addFruit"]) {
        upcoming.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:upcoming action:@selector(cancelAdd)];
        upcoming.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:upcoming action:@selector(addNewFruit)];
    }
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

#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Fruits *item = self.fruits[indexPath.row];
    
    cell.textLabel.text = item.name;
    NSLog(@"Fruit's Name: %@", item.name);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Fruits *item = self.fruits[indexPath.row];
    FruitsDetaitVC *detail = [FruitsDetaitVC new];
    detail.fruit = item;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
