//
//  DetailsViewController.swift
//  AppnomiCase
//
//  Created by Murat Çiçek on 9.09.2022.
//

import UIKit
import SnapKit

protocol DetailsViewInterface: AnyObject {
    func viewDidLoadConfigure()
    func scrollConfigure()
    func styleConfigure()
    func snapkitConfigure()

}

class DetailsViewController: AppnomiBaseViewController {
    private let scrollView = UIScrollView()
    private let uiView = UIView()
    private let imageView = UIImageView()
    private let detailsHeaderLabel = UILabel()
    private let detailsPriceLabel = UILabel()
    private let detailsDiscountedPriceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stockIcon = UIImageView()
    private let stockLabel = UILabel()
    private let viewModel = DetailsViewModel()

    let productID: String
    init(productID: String) {
        self.productID = productID
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    private func scroll() {
        viewModel.scroll()
    }
    private func applyStyle() {
        viewModel.applyStyle()
    }
    private func setSnapkit() {
        viewModel.setSnapkit()

    }
    @objc func shopTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Sepete eklendi")
    }
}

extension DetailsViewController: DetailsViewInterface {
    func snapkitConfigure() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(-35)
            make.left.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().offset(descriptionLabel.frame.maxY)

        }
        uiView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.right.equalTo(scrollView.snp.right)
            make.left.equalTo(scrollView.snp.left)
            make.size.equalTo(CGSize(width: 350, height: 1200))

        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(35)
            make.right.equalToSuperview().offset(-35)
            make.left.equalToSuperview().offset(35)
            make.size.equalTo(CGSize(width: UIScreen.width, height: 250))

        }
        detailsHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-35)
            make.left.equalToSuperview().offset(35)
        }
        detailsPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsHeaderLabel.snp.bottom).offset(15)
            make.right.equalTo(detailsDiscountedPriceLabel.snp.left).offset(-5)

        }
        detailsDiscountedPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsHeaderLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(stockIcon.snp.bottom).offset(15)
            make.right.equalTo(scrollView.snp.right)
            make.left.equalTo(scrollView.snp.left)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-50)
        }
        stockIcon.snp.makeConstraints { make in
            make.top.equalTo(detailsDiscountedPriceLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 24, height: 24))

        }
        stockLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsDiscountedPriceLabel.snp.bottom).offset(15)
            make.left.equalTo(stockIcon.snp.right).offset(15)
        }
    }

    func styleConfigure() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shopTapped(tapGestureRecognizer:)))
        logo.isUserInteractionEnabled = true
        logo.addGestureRecognizer(tapGestureRecognizer)
        logo.image = UIImage(named: "basket_icon")
        imageView.image = UIImage(named: "appnomi_logo")
        imageView.contentMode = .scaleToFill
        detailsHeaderLabel.styleLabel(title: "Deneme Baslik", textAlignment: .center, color: .black, fontSize: UIFont.systemFont(ofSize: 24))
        detailsPriceLabel.styleLabel(title: "50", textAlignment: .center, color: .lightGray, fontSize: UIFont.systemFont(ofSize: 20))
        detailsDiscountedPriceLabel.styleLabel(title: "30", textAlignment: .center, color: .black, fontSize: UIFont.systemFont(ofSize: 20))
        scrollView.showsVerticalScrollIndicator = false
        descriptionLabel.styleLabel(title: "sundae", textAlignment: .center, color: .black, fontSize: UIFont.systemFont(ofSize: 20))
        stockIcon.image = UIImage(named: "stock_icon")?.withRenderingMode(.alwaysTemplate)
        stockIcon.contentMode = .scaleToFill
        stockIcon.tintColor = .green
        stockLabel.styleLabel(title: "Stokta var", textAlignment: .center, color: .green, fontSize: UIFont.systemFont(ofSize: 18))
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func scrollConfigure() {
        scrollView.alwaysBounceVertical = true
        scrollView.scrollsToTop = false
    }

    func viewDidLoadConfigure() {
        view.addSubviews(scrollView)
        scrollView.addSubview(uiView)
        uiView.addSubviews(descriptionLabel, imageView, detailsHeaderLabel, detailsPriceLabel, detailsDiscountedPriceLabel, stockIcon, stockLabel)
        scroll()
        applyStyle()
        setSnapkit()
        viewModel.getSingleProduct(productId: productID)
    }


}

extension DetailsViewController: ViewModelSingleProductFetch {
    func didFinishedGetSingleProduct(data: SingleProductDetailModel) {
        guard let data = data.data else {
            return
        }
        DispatchQueue.main.async {

            if data.campaignPrice != nil {
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: (data.price?.toString ?? "") + "$")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                self.detailsPriceLabel.attributedText = attributeString
            }
            else {
                self.detailsPriceLabel.text = (data.price?.toString ?? "") + "$"
            }
            self.detailsHeaderLabel.text = data.title ?? ""
            self.descriptionLabel.text = data.datumDescription?.htmlToAttributedString?.string
            self.stockLabel.text = data.stock?.toString ?? ""
            self.detailsDiscountedPriceLabel.text = data.campaignPrice?.toString ?? "0" + " USD"
            self.imageView.setImage(with: data.images?.first?.nyp)
            if data.campaignPrice == nil {
                self.detailsDiscountedPriceLabel.isHidden = true
                self.detailsPriceLabel.textColor = .black
                self.detailsPriceLabel.text = (data.price?.toString ?? "") + "$"
            }
            if data.stock == 0 {
                self.stockIcon.tintColor = .red
                self.stockLabel.textColor = .red
            }
            Logger.log(type: .warning, text: data.datumDescription ?? "")
            self.stopAndHideSpinner()
        }

    }

    func didErrorGetSingleProducts(error: CustomError) {

    }
}
