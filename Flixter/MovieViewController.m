//
//  MovieViewController.m
//  Flixter
//
//  Created by Myles Block on 6/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
//#import "UIImageview+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=66fe3a93e9f4d8ebf87b88234f2739df"];
    //API Key changed to v3
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movies in self.movies)
               {
                   NSLog(@"%@", movies[@"title"]);
               }
//               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.TableView reloadData];
           }
       }];
    [task resume];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.MovieTitle.text = movie [@"title"];
    cell.MovieDescription.text = movie [@"overview"];
    
    
//    NSString *baseURLString = @"
    
    return cell;
}


@end
