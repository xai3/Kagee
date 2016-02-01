# Kagee
Easily way to write a stub for the network request

## Usage

Please call the `MockProtocol.register()` when app is launched.

##### iOS example

``` swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    MockProtocol.register()
    return true
}
```

You can create a stub with the `Mock.up()`. And using `request` and `response` to defined the content.

``` swift
Mock.up().request(url: "/").response(200, body: nil, header: nil)
```

Write a network request using the usual `NSURLSession` or `Alamofire`.

##### NSURLSession

``` swift
let request = NSURLRequest(URL: NSURL(string: "/")!)
let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
session.dataTaskWithRequest(request) { data, response, error in
    let httpResponse = response as! NSHTTPURLResponse
    // Status code is 200 !!!
    ex.fulfill()
}.resume()
```

##### Alamofire

``` swift
Alamofire.request(.GET, "/").response { _, response, _, _ in
    // Status code is 200 !!!
}
```

### Stub data of JSON object

Pass the `JSON` to the `body`.

``` swift
let json: [String: AnyObject] = ["name": "yukiasai", "age": 28]
Mock.up().request(url: url).response(200, body: JSON(json), header: nil)
```

### Stub data from file

``` swift
let fileUrl: NSURL = NSURL(string: "path/to/file")!
Mock.up().request(url: url).response(200, body: File(fileUrl), header: nil)
```

### Response handler

You can also write the `responseHandler`.

``` swift
Mock.up().request(url: someUrl).response { request -> Response in
    let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
    let data = "12345".dataUsingEncoding(NSUTF8StringEncoding)
    return .Success(response, data)
    // or return .Failure(error)
}
```

### Network speed

You can control speed by using the `speed()`. Speed will change depending on the size of the http-body data.

``` swift
Mock.up().request(url: url).response(200, body: File(fileUrl), header: nil).speed(.Wifi)
```

It supports the following speed.

``` swift
public enum Speed {
    case Prompt
    case Wifi      // 45Mbps
    case Mobile4G  // 10Mbps
    case Mobile3G  // 1Mbps
    case Edge      // 200kbps
}
```

## License

Kagee is released under the MIT license. See LICENSE for details.
