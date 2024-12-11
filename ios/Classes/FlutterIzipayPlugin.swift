import Flutter
import UIKit
import IzipayPayButtonSDK
import VisaSensoryBranding
import MastercardSonic

public class FlutterIzipayPlugin: NSObject, FlutterPlugin, IzipayPaymentDelegate {

  private let sonicManager: MCSonicController = MCSonicController()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_izipay", binaryMessenger: registrar.messenger())
    let instance = FlutterIzipayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "openFormToSaveCard":
      if let args = call.arguments as? [String: String] {
        let environment = args["environment"]!
        let merchantCode = args["merchantCode"]!
        let publicKey = args["publicKey"]!
        let transactionId = args["transactionId"]!
        let action = args["action"]!

        openFormToSaveCard(
          environment: environment,
          merchantCode: merchantCode,
          publicKey: publicKey,
          transactionId: transactionId,
          action: action
        )
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func openFormToSaveCard(
    environment: String,
    merchantCode: String,
    publicKey: String,
    transactionId: String,
    action: String
  ) {
    let random = Int.random(in: 356547157..<366547157)
    let tranxId = "\(random)"

    print(tranxId)
    
    var configPayment = ConfigPaymentIzipay()
    configPayment.enviroment = environment
    configPayment.merchantCode = merchantCode

    configPayment.publicKey = publicKey

    configPayment.transactionId = tranxId
    configPayment.action = "register"

    configPayment.order = OrderPaymentIzipay()
    configPayment.order?.orderNumber = "10\(random)"
    configPayment.order?.amount = "2.00" // si action=register puede ser 0, si no
    configPayment.order?.currency = "PEN"
    configPayment.order?.processType = "autorize"
    configPayment.order?.payMethod = [.all]
    configPayment.order?.merchantBuyerId = "MB10\(random)"

    //...
    configPayment.billing = BillingPaymentIzipay()
    configPayment.billing?.firstName = "Jose"
    configPayment.billing?.lastName = "Perez"
    configPayment.billing?.email = "jperez@itest.com"
    configPayment.billing?.phoneNumber = "958745896"
    configPayment.billing?.street = "Av. Jorge Chávez 275"
    configPayment.billing?.city = "Lima"
    configPayment.billing?.state = "Lima"

    //...
    configPayment.shipping = ShippingPaymentIzipay()

    //...
    configPayment.token = TokenPaymentIzipay()

    configPayment.appearance = AppearencePaymentIzipay()
    configPayment.appearance?.theme = "green"
    configPayment.appearance?.logo = "URL"
    configPayment.appearance?.formControls = AppearenceControlsPaymentIzipay()
    configPayment.appearance?.formControls?.isAmountLabelVisible = true
    configPayment.appearance?.formControls?.isLangControlVisible = true
    configPayment.appearance?.language = "ESP"
    configPayment.appearance?.customTheme = CustomThemePaymentIzipay()

    configPayment.urlIPN = nil

    let s = UIStoryboard(name: "IziPayment", bundle: Bundle(for: PaymentFormViewController.self))
    let vc =
      s.instantiateViewController(withIdentifier: "PaymentFormView") as! PaymentFormViewController
    vc.delegate = self
    vc.configPayment = configPayment
    vc.modalPresentationStyle = .fullScreen

    guard
      let rootViewController = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow })?.rootViewController
    else {
      print("No se pudo obtener el rootViewController")
      return
    }

    DispatchQueue.main.async {
      rootViewController.present(vc, animated: true, completion: nil)
    }
  }

  public func getPaymentResult(_ paymentResult: PaymentResult) {
    print(paymentResult.code ?? "")
    print(paymentResult.message ?? "")
  }

  public func executeProfiling(_ result: IzipayPayButtonSDK.ScoringParams) {

  }

  public func executeSensoryBrandVisa(view: UIView) {
    if let visaview = view as? SensoryBranding {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        visaview.animate()
      }
    }
  }

  public func executeSensoryBrandMastercard(
    view: UIView, params: IzipayPayButtonSDK.MastercardSonicParams
  ) {
    let merchant = MCSonicMerchant(
      merchantName: params.name, countryCode: params.country,
      city: nil, merchantCategoryCodes: [params.mcc], merchantId: nil)
    if let mastercardview = view as? MCSonicView, let safeMerchant = merchant {
      self.sonicManager.prepare(
        with: .soundAndAnimation, sonicCue: params.sonicCue,
        sonicEnvironment: .production, merchant: safeMerchant
      ) { status in
        if status == .success {
          self.sonicManager.play(with: mastercardview) { MCSonicStatus in
            print(MCSonicStatus)
          }
        }
      }
    }
  }
}
