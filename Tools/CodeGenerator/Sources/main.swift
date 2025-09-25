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
        validateOpenApiSpec(at: destination)
    }
    catch{
        print("File error \(error)")
        exit(1)
    }

    exit(0)
 }

 task.resume()
 RunLoop.main.run()

func validateOpenApiSpec(at url: URL){
    do{
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [])

        // check open api version
        guard let json = json as? [String: Any],
              let openapi = json["openapi"] as? String,
              openapi == "3.0.0" else{

            print("Invalid open api version")
            exit(1)
        }
        
        print("Open api version is \(openapi)")

        if let info = json["info"] as? [String: Any]{
            for (key, value) in info {
                print("\(key): \(value)")
            }
        }
        extractSchemas(from: json)
    }
    catch{
        print("Error validating open api spec \(error)")
        exit(1)
    }
}

func extractSchemas(from json: [String: Any]){
    print("Startingto extract types")
    
    if let components = json["components"] as? [String: Any],
    let schemas = components["schemas"] as? [String: Any] {
        for (schemaName, _) in schemas {
            print(schemaName)
        }

        print("Types count: \(schemas.count)")
    }
}