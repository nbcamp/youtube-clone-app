import PhotosUI

final class PhotoPicker: NSObject, PHPickerViewControllerDelegate {
    let completion: ([UIImage]) -> Void

    init(completion: @escaping ([UIImage]) -> Void) {
        self.completion = completion
        super.init()
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var loadedImages: [UIImage] = []

        let dispatchGroup = DispatchGroup()

        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    loadedImages.append(image)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.completion(loadedImages)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
