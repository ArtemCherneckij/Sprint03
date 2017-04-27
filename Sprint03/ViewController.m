#import "ViewController.h"
#import "UITaTableViewCell.h"
#import "AppInfo.h"
#import "DetailViewController.h"
#import "Fruits.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    NSURLSession *session;
    NSMutableArray *tableData;
    NSEntityDescription *entity;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindcator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    entity = [NSEntityDescription entityForName:@"Fruits" inManagedObjectContext:[self managedObjectContext]];
    for (Fruits *object in tableData) {
        NSLog(@"Found %@",object.title);
    }
    [self fruitsadds];
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Fruits"];
//    tableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

//Code for ReloadData

-(void) reloadDataFromNet
{
    [self.activityindcator startAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Обновление" message:@"Таблица обновлена" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/ArtemCherneckij/Sprint02/master/Artem.json"];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Обновление" message:@"Таблица не обновлена" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [self.activityindcator stopAnimating];
            [alertError show];
        }else{
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *appArr = [NSMutableArray new];
            for (NSDictionary *dic in arr) {
                [appArr addObject:[[AppInfo alloc]initWithDictionary:dic]];
            }
            tableData = appArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.activityindcator stopAnimating];
                [alert show];
            });
        }
    }]resume];
}

//Code for Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    AppInfo *info = tableData[indexPath.row];

    cell.title.text = info.title;
    cell.subtitle.text = info.subtitle;
    
//    NSManagedObject *fruits = [tableData objectAtIndex:indexPath.row];
//    [cell.title setText:[info valueForKey:@"genus"]];
//    [cell.subtitle setText:[info valueForKey:@"title"]];
    
    [[session dataTaskWithURL:info.imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.image.image= img;
        });
    }]resume];

    return  cell;
}

- (IBAction)ReloadDataFromTable:(id)sender {
    [self reloadDataFromNet];
    
    [self.tableView reloadData];
}

//Code for Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showdetail"]) {
        
        NSIndexPath *indexPath=nil;
        indexPath =[self.tableView indexPathForSelectedRow];
        
        AppInfo *info = tableData[indexPath.row];
        
        DetailViewController *detailviewcontroller = segue.destinationViewController;
        detailviewcontroller.eventName=info.title;
        detailviewcontroller.eventSubName=info.subtitle;
        [[session dataTaskWithURL:info.imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            UIImage *img = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                detailviewcontroller.imagedetail.image = img;
            });
        }]resume];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fruitsadds{
    NSError *error=nil;
    for(int i=0;i<tableData.count;i++){
    NSManagedObject *context=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:[self managedObjectContext]];
        [context setValue:[[tableData objectAtIndex:i]objectForKey:@"title" ] forKey:@"title"];
        [[self managedObjectContext] save:&error];
}
}

@end

