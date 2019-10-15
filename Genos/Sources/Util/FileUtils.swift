//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct FileUtils {
    public static let PATH_DOCUMENTS: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    // TODO: 把所有[0] 和 IndexPath(row: 0, section: 0)换为first

    /// 保存文件并自动创建父文件夹.
    public static func saveFile(_ path: String, data: Data?) -> Bool {
        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: path).deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        } catch {
            log.error("📂 创建 文件目录 失败: \(error)")
        }
        return FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        // data?.writeToFile(path, atomically: true)
    }

    /// 列出打包目录的文件URL.
    public static func listAssets(_ path: String) -> [URL] {
        listUrls((Bundle.main.resourceURL?.appendingPathComponent(path).path)!) // 处理强转
    }

    /// 列出目录下文件的URL, 默认不显示隐藏文件.
    public static func listUrls(_ directory: String, pathExtension: String? = nil, options: FileManager.DirectoryEnumerationOptions = .skipsHiddenFiles) -> [URL] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: nil, options: options)
            // TIP: 闭包的简便写法
            return pathExtension == nil ? urls : urls.filter { $0.pathExtension == pathExtension }
        } catch {
            log.error("📂 列出 文件目录 失败: \(error)")
        }
        return []
    }
}
