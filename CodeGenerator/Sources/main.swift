import Foundation

// Get open api near spec
let url = URL(string: "https://raw.githubusercontent.com/near/nearcore/master/chain/jsonrpc/openapi/openapi.json")!
print("Getting near open api spec file location url \(url)")

// Get destination url path
let currentDir = FileManager.default.currentDirectoryPath
let destination = URL(fileURLWithPath: currentDir).appendingPathComponent("open-api-near-spec.json")

print("Open api download destination \(destination.path)")

// Start download from a url
let task = URLSession.shared.downloadTask(with: url) {tempURL, response, error in
    if let error = error{
        print("Download failed! \(error)")         
        exit(1)
    }
    
    guard let tempURL = tempURL else{
        print("No url recieved")
        exit(1)
    }

    do{
        if FileManager.default.fileExists(atPath: destination.path){
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.moveItem(at: tempURL, to: destination)
        print("File saved to destination \(destination.path)") 
    }
    catch{
        print("File error \(error)")
        exit(1)
    }

    exit(0)
 }

 task.resume()
 RunLoop.main.run()
