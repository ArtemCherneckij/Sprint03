#import "ViewController.h"
#import "UITaTableViewCell.h"
#import "AppInfo.h"
#import "DetailViewController.h"
#import "Fruits.h"

@interface ViewController ()
{
    NSURLSession *session;
    NSMutableArray *tableData;
    NSMutableArray *array;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

//Code for ReloadData

-(void) reloadDataFromNet
{
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/ArtemCherneckij/Sprint02/master/Artem.json"];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSLog(@"Not load data(error)");
        }else{
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *appArr = [NSMutableArray new];
            for (NSDictionary *dic in arr) {
                [appArr addObject:[[AppInfo alloc]initWithDictionary:dic]];
            }
            tableData = appArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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
    [[session dataTaskWithURL:info.imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.image.image= img;
        });
    }]resume];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //todo present view controller
}

- (IBAction)ReloadDataFromTable:(id)sender {
    [self reloadDataFromNet];
    
    //NSManagedObjectContext *context = [self managedObjectContext];
    
    //NSManagedObject *newFruits = [NSEntityDescription insertNewObjectForEntityForName:@"Fruits" inManagedObjectContext:context];
    //[newFruits setValue:@"Cherry" forKey:@"title"];
    //[newFruits setValue:@"Rainiers" forKey:@"subtitle"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Обновление" message:@"Таблица обновлена" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
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
@end

