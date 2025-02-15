import Flutter
import IzipayPayButtonSDK
import MastercardSonic
import UIKit
import VisaSensoryBranding

public class FlutterIzipayPlugin: NSObject, FlutterPlugin, IzipayPaymentDelegate {
  private var eventSink: FlutterEventSink?

  private let sonicManager: MCSonicController = MCSonicController()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "flutter_izipay/method_channel", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "flutter_izipay/event_channel", binaryMessenger: registrar.messenger())

    let instance: FlutterIzipayPlugin = FlutterIzipayPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "openFormToSaveCard":
      if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        rootViewController.overrideUserInterfaceStyle = .light
      }

      guard let args = call.arguments as? [String: String] else { return }

      openFormToSaveCard(data: args)
    case "payWithCard":
      if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        rootViewController.overrideUserInterfaceStyle = .light
      }

      guard let args = call.arguments as? [String: String] else { return }

      payWithCard(data: args)
    case "payWithYape":
      if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        rootViewController.overrideUserInterfaceStyle = .light
      }

      guard let args = call.arguments as? [String: String] else { return }

      payWithYape(data: args)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func openFormToSaveCard(data: [String: String]) {
    print("openFormToSaveCard: \(data)")
  }

  func payWithCard(data: [String: String]) {
    let date = Date()
    let milliseconds = Int(date.timeIntervalSince1970 * 1000)

    var configPayment = ConfigPaymentIzipay()
    configPayment.enviroment = data["environment"]
    configPayment.action = "pay"
    configPayment.publicKey = data["publicKey"]
    configPayment.transactionId = data["transactionId"]
    configPayment.merchantCode = data["merchantCode"]

    configPayment.order = OrderPaymentIzipay()
    configPayment.order?.orderNumber = data["orderNumber"]
    configPayment.order?.currency = "PEN"
    configPayment.order?.amount = data["amount"]
    configPayment.order?.payMethod = [PaymentMethodIzipay.card]

    configPayment.order?.processType = "autorize"
    configPayment.order?.merchantBuyerId = data["userId"]
    configPayment.order?.dateTimeTransaction = "\(milliseconds)"

    configPayment.token = TokenPaymentIzipay()

    configPayment.billing = BillingPaymentIzipay()
    configPayment.billing?.firstName = data["firstName"]
    configPayment.billing?.lastName = data["lastName"]
    configPayment.billing?.email = data["email"]
    configPayment.billing?.phoneNumber = data["phoneNumber"]
    configPayment.billing?.street = data["street"]
    configPayment.billing?.city = data["city"]
    configPayment.billing?.state = data["state"]
    configPayment.billing?.country = data["country"]
    configPayment.billing?.postalCode = data["postalCode"]
    configPayment.billing?.documentType = data["documentType"]
    configPayment.billing?.document = data["documentNumber"]

    configPayment.shipping = ShippingPaymentIzipay()

    configPayment.appearance = AppearencePaymentIzipay()
    configPayment.appearance?.language = "ESP"
    configPayment.appearance?.formControls = AppearenceControlsPaymentIzipay()
    configPayment.appearance?.formControls?.isAmountLabelVisible = true
    configPayment.appearance?.formControls?.isLangControlVisible = false
    configPayment.appearance?.visualSettings = AppearenceVisualSettingsPaymentIzipay()
    configPayment.appearance?.visualSettings?.presentationMode = .fullscreen
    configPayment.appearance?.theme = "purple"
    configPayment.appearance?.customTheme = CustomThemePaymentIzipay()
    configPayment.appearance?.logo = data["logoUrl"]

    let sensoryBrandingVisa = SensoryBranding()
    sensoryBrandingVisa.backdropColor = .white
    sensoryBrandingVisa.isSoundEnabled = true
    sensoryBrandingVisa.isHapticFeedbackEnabled = true
    sensoryBrandingVisa.checkmarkMode = .checkmark

    let sensoryBrandMastercard = MCSonicView()
    sensoryBrandMastercard.background = MCSonicBackground.white

    configPayment.appearance?.sensoryBrand = AppearenceSensoryBrandIzipay()
    configPayment.appearance?.sensoryBrand?.visaSBView = sensoryBrandingVisa
    configPayment.appearance?.sensoryBrand?.mastercardSBView = sensoryBrandMastercard

    configPayment.urlIPN = data["webhookUrl"]

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

  func payWithYape(data: [String: String]) {
    
    let date = Date()
    let milliseconds = Int(date.timeIntervalSince1970 * 1000)

    var configPayment = ConfigPaymentIzipay()
    configPayment.enviroment = data["environment"]
    configPayment.action = "pay"
    configPayment.publicKey = data["publicKey"]
    configPayment.transactionId = data["transactionId"]
    configPayment.merchantCode = data["merchantCode"]

    configPayment.order = OrderPaymentIzipay()
    configPayment.order?.orderNumber = data["orderNumber"]
    configPayment.order?.currency = "PEN"
    configPayment.order?.amount = data["amount"]
    configPayment.order?.payMethod = [PaymentMethodIzipay.yape_code]

    configPayment.order?.processType = "autorize"
    configPayment.order?.merchantBuyerId = data["userId"]
    configPayment.order?.dateTimeTransaction = "\(milliseconds)"

    configPayment.token = TokenPaymentIzipay()

    configPayment.billing = BillingPaymentIzipay()
    configPayment.billing?.firstName = data["firstName"]
    configPayment.billing?.lastName = data["lastName"]
    configPayment.billing?.email = data["email"]
    configPayment.billing?.phoneNumber = data["phoneNumber"]
    configPayment.billing?.street = data["street"]
    configPayment.billing?.city = data["city"]
    configPayment.billing?.state = data["state"]
    configPayment.billing?.country = data["country"]
    configPayment.billing?.postalCode = data["postalCode"]
    configPayment.billing?.documentType = data["documentType"]
    configPayment.billing?.document = data["documentNumber"]

    configPayment.shipping = ShippingPaymentIzipay()

    configPayment.appearance = AppearencePaymentIzipay()
    configPayment.appearance?.language = "ESP"
    configPayment.appearance?.formControls = AppearenceControlsPaymentIzipay()
    configPayment.appearance?.formControls?.isAmountLabelVisible = true
    configPayment.appearance?.formControls?.isLangControlVisible = false
    configPayment.appearance?.visualSettings = AppearenceVisualSettingsPaymentIzipay()
    configPayment.appearance?.visualSettings?.presentationMode = .fullscreen
    configPayment.appearance?.theme = "purple"
    configPayment.appearance?.customTheme = CustomThemePaymentIzipay()
    configPayment.appearance?.logo = data["logoUrl"]

    let sensoryBrandingVisa = SensoryBranding()
    sensoryBrandingVisa.backdropColor = .white
    sensoryBrandingVisa.isSoundEnabled = true
    sensoryBrandingVisa.isHapticFeedbackEnabled = true
    sensoryBrandingVisa.checkmarkMode = .checkmark

    let sensoryBrandMastercard = MCSonicView()
    sensoryBrandMastercard.background = MCSonicBackground.white

    configPayment.appearance?.sensoryBrand = AppearenceSensoryBrandIzipay()
    configPayment.appearance?.sensoryBrand?.visaSBView = sensoryBrandingVisa
    configPayment.appearance?.sensoryBrand?.mastercardSBView = sensoryBrandMastercard

    configPayment.urlIPN = data["webhookUrl"]

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
    let resultCode = paymentResult.code ?? ""

    if resultCode == "00" {
      let dataToSend: [String: Any?] = [
        "success": true,
        "code": paymentResult.code,
        "cardToken": paymentResult.response?.token?.cardToken,
        "cardPan": paymentResult.response?.card?.pan,
        "cardBrand": paymentResult.response?.card?.brand,
      ]
      self.sendResultToFlutter(result: dataToSend)
    } 
    else {
      let dataToSend: [String: Any?] = [
        "success": false,
        "code": paymentResult.code,
      ]
      self.sendResultToFlutter(result: dataToSend)
    }
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
extension FlutterIzipayPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  public func sendResultToFlutter(result: [String: Any?]) {
    if let sink = eventSink {
      sink(result)
    }
  }
}
