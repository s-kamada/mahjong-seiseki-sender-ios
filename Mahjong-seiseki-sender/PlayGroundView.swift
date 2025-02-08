//
//  PlayGroundViewController.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2025/01/21.
//

import Foundation
import Vision
import SwiftUI

/// Vision APIのテスト実装。
/// 矩形認識、文字認識、顔認識を画像2種類に対して適用できる。
struct PlayGroundView: View {
    @State var result = "text recognize result is here"
    @State var rects: [CGRect] = []
    @State var image = Images.sansanlp.image

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .border(Color.black, width: 2)

                Path { path in
                    path.addRects(rects)
                }
                .stroke(lineWidth: 2)
                .fill(Color.red)
                .border(Color.green, width: 2)
            }

            Button(action: {
                executeTextRecognition(image: image) { result in
                    self.result = result
                }
            }, label: {
                Text("Text Recognize")
            })

            Button(action: {
                executeRectangleRecognition(image: image) { rects in
                    self.rects = rects
                    print("rects: \(self.rects)")
                }
            }, label: {
                Text("Rect Recognize")
            })

            Button(action: {
                executeFaceRecognition(image: image) { rects in
                    self.rects = rects
                    print("face rects: \(self.rects)")
                }
            }, label: {
                Text("Face Recognize")
            })

            Button(action: {
                switch image {
                case .sansanlp:
                    self.image = .ourteam
                case .ourteam:
                    self.image = .sansanlp
                default:
                    self.image = .sansanlp
                }
                // 出力されたrectやtextも消さないと
                self.rects = []
                self.result = "text recognize result is here"
            }, label: {
                Text("Toggle Image")
            })

            Text(result).lineLimit(99)
        }
    }
}

/**
 * 実装の大枠はどれも一緒。
 * let request = VN(やりたいこと)Request
 * let handler = VNImageRequestHandler(cgImage:,options: [:])
 * handler.perform([request])
 */
// 顔認識する
func executeFaceRecognition(image: UIImage, completion: @escaping ([CGRect]) -> ()) {
    let faceDetectRequest = VNDetectFaceRectanglesRequest { (request, error) in
        if let results = request.results as? [VNFaceObservation] {
            var rects: [CGRect] = []
            for obserbation in results {
                rects.append(obserbation.toCGRect(image: image))
            }
            completion(rects)
        }
    }

    let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

    Task {
        do {
            #if targetEnvironment(simulator)
            faceDetectRequest.usesCPUOnly = true
            #endif
            try handler.perform([faceDetectRequest])
        } catch {
            print(error)
        }
    }
}

//　矩形認識する
func executeRectangleRecognition(image: UIImage, completion: @escaping ([CGRect]) -> ()) {

    let request = VNDetectRectanglesRequest { (request, error) in
        if let results = request.results as? [VNRectangleObservation] {
            var rects: [CGRect] = []
            for observation in results {
                rects.append(observation.toCGRect(image: image))
            }
            completion(rects)
        }
    }
    request.minimumSize = 0.1
    request.maximumObservations = 8

    let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

    Task {
        do {
            try handler.perform([request])
        } catch {
            print("error: \(error)")
        }
    }
}

// 文字認識する
func executeTextRecognition(image: UIImage, completion: @escaping (String) -> ()) {

    let request = VNRecognizeTextRequest{ (request, error) in
        if let error {
            print("error: \(error)")
        }

        if let results = request.results as? [VNRecognizedTextObservation] {
            var texts = ""
            for observation in results {
                if let recognizedText = observation.topCandidates(1).first {
                    print(recognizedText.string)
                    texts.append(recognizedText.string + "\n")
                }
            }
            completion(texts)
        }
    }

    request.recognitionLanguages = ["ja-JP"]

    let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    Task {
        do {
            try handler.perform([request])
        } catch {
            print("error: \(error)")
        }
    }
}

#Preview {
    PlayGroundView()
}

enum Images {
    case sansanlp
    case ourteam

    var image: UIImage {
        switch self {
        case .sansanlp:
            return UIImage(named: "sansanlp")!
        case .ourteam:
            return UIImage(named: "ourteam")!
        }
    }
}

extension VNRectangleObservation {
    func toCGRect(image: UIImage) -> CGRect {
        let imageaspect = image.size.height / image.size.width
        // 画像サイズは横幅 = 画面幅に調整されている前提
        let actual = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * imageaspect)

        let boundingBox = self.boundingBox
        let size = CGSize(width: boundingBox.width * actual.width, height: boundingBox.height * actual.height)
        let origin = CGPoint(x: boundingBox.minX * actual.width, y: (1 - boundingBox.minY - boundingBox.height) * actual.height)

        print("origin: \(origin), size: \(size)")
        return CGRect(origin: origin, size: size)
    }
}

extension VNFaceObservation {
    func toCGRect(image: UIImage) -> CGRect {
        let imageaspect = image.size.height / image.size.width
        // 画像サイズは横幅 = 画面幅に調整されている前提
        let actual = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * imageaspect)

        let boundingBox = self.boundingBox
        let size = CGSize(width: boundingBox.width * actual.width, height: boundingBox.height * actual.height)
        let origin = CGPoint(x: boundingBox.minX * actual.width, y: (1 - boundingBox.minY - boundingBox.height) * actual.height)

        print("origin: \(origin), size: \(size)")
        return CGRect(origin: origin, size: size)
    }
}
