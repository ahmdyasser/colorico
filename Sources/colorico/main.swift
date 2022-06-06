import ArgumentParser
import Foundation

struct Colorico: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "colorize", abstract: "Colorico adds color to text using console escape sequences", usage: "change the color lol", version: "1.0.0"
    )
    enum Color: Int {
        case red = 31
        case green = 32
    }
    @Argument(help: "text to color.")
    var text: String
    
    @Flag(inversion: .prefixedNo)
    var good = true
    
    @Option(name: [.customShort("o"), .long], help: "name of output file(the command only writes to current directory)")
    var outputFile: String?
    
    mutating func run() throws {
        var color = Color.green.rawValue
        if !good {
            color = Color.red.rawValue
        }
        
        let coloredText = "\u{1B}[\(color)m\(text)\u{1B}[0m"
        if let outputFile = outputFile {
            let path = FileManager.default.currentDirectoryPath
            
            let filename = URL(fileURLWithPath: outputFile).lastPathComponent
            let fullFilename = URL(fileURLWithPath: path).appendingPathComponent(filename)
            try coloredText.write(to: fullFilename, atomically: true, encoding: String.Encoding.utf8)
        } else {
            print(coloredText)
        }
    }
}

Colorico.main()
