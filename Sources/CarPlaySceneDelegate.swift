import UIKit
import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?

    // Hàm tự động chạy khi cắm iPhone 8 Plus vào xe
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController) {
        self.interfaceController = interfaceController

        // Khởi tạo 2 Tab chức năng chính trên màn hình xe
        let gridTab = createQuickActionGrid()
        let listTab = createCustomListScreen()

        let tabBarTemplate = CPTabBarTemplate(templates: [gridTab, listTab])
        interfaceController.setRootTemplate(tabBarTemplate, animated: true, completion: nil)
    }

    // ---------------------------------------------------------
    // TAB 1: MÀN HÌNH LƯỚI NÚT BẤM ĐIỀU KHIỂN NHANH
    // ---------------------------------------------------------
    func createQuickActionGrid() -> CPGridTemplate {
        // Nút chức năng 1: Gửi lệnh qua mạng (Webhook / API / Server cá nhân)
        let btnAction1 = CPGridButton(titleVariants: ["Chạy Lệnh 1"],
                                      image: UIImage(systemName: "bolt.circle.fill")!) { [weak self] _ in
            self?.triggerCustomWebhook(endpoint: "https://httpbin.org/get")
        }

        // Nút chức năng 2: Hiển thị hộp thoại thông báo trên màn hình xe
        let btnAction2 = CPGridButton(titleVariants: ["Kiểm Tra Hệ Thống"],
                                      image: UIImage(systemName: "cpu.fill")!) { [weak self] _ in
            self?.showCarPlayAlert(title: "Trạng thái OK", message: "Kết nối từ iPhone 8 Plus hoạt động ổn định.")
        }

        let grid = CPGridTemplate(title: "Điều Khiển", gridButtons: [btnAction1, btnAction2])
        grid.tabTitle = "Điều Khiển"
        grid.tabImage = UIImage(systemName: "square.grid.2x2.fill")
        return grid
    }

    // ---------------------------------------------------------
    // TAB 2: MÀN HÌNH DANH SÁCH TÁC VỤ / THÔNG TIN
    // ---------------------------------------------------------
    func createCustomListScreen() -> CPListTemplate {
        let item1 = CPListItem(text: "Tác vụ tự định nghĩa A",
                               detailText: "Bấm để thực thi hàm nội bộ",
                               image: UIImage(systemName: "play.circle.fill"))
        item1.handler = { [weak self] _, completion in
            // Viết logic xử lý riêng của bạn tại đây
            self?.showCarPlayAlert(title: "Đã chạy Tác vụ A", message: "Hoàn tất xử lý!")
            completion()
        }

        let item2 = CPListItem(text: "Tác vụ tự định nghĩa B",
                               detailText: "Cập nhật dữ liệu thời gian thực",
                               image: UIImage(systemName: "arrow.triangle.2.circlepath"))
        item2.handler = { _, completion in
            completion()
        }

        let section = CPListSection(items: [item1, item2])
        let list = CPListTemplate(title: "Danh Sách", sections: [section])
        list.tabTitle = "Danh Sách"
        list.tabImage = UIImage(systemName: "list.bullet")
        return list
    }

    // ---------------------------------------------------------
    // CÁC HÀM XỬ LÝ LOGIC TÙY CHỈNH CỦA BẠN
    // ---------------------------------------------------------
    func triggerCustomWebhook(endpoint: String) {
        guard let url = URL(string: endpoint) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showCarPlayAlert(title: "Lỗi kết nối", message: error.localizedDescription)
                } else {
                    self?.showCarPlayAlert(title: "Thành công", message: "Đã gửi lệnh tới Server!")
                }
            }
        }.resume()
    }

    func showCarPlayAlert(title: String, message: String) {
        let okAction = CPAlertAction(title: "Đóng", style: .default) { [weak self] _ in
            self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
        }
        let alertTemplate = CPAlertTemplate(titleVariants: ["\(title): \(message)"], actions: [okAction])
        interfaceController?.presentTemplate(alertTemplate, animated: true, completion: nil)
    }
}