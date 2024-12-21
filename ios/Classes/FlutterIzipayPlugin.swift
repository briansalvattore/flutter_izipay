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

      if let args = call.arguments as? [String: String] {
        let street = args["street"]!
        let city = args["city"]!
        let state = args["state"]!
        let country = args["country"]!
        let postalCode = args["postalCode"]!
        let logoUrl = args["logoUrl"]!
        let userId = args["userId"]!
        let firstName = args["firstName"]!
        let lastName = args["lastName"]!
        let email = args["email"]!
        let phoneNumber = args["phoneNumber"]!
        let documentType = args["documentType"]!
        let documentNumber = args["documentNumber"]!
        let environment = args["environment"]!
        let merchantCode = args["merchantCode"]!
        let publicKey = args["publicKey"]!
        let transactionId = args["transactionId"]!

        openFormToSaveCard(
          street: street,
          city: city,
          state: state,
          country: country,
          postalCode: postalCode,
          logoUrl: logoUrl,
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          documentType: documentType,
          documentNumber: documentNumber,
          environment: environment,
          merchantCode: merchantCode,
          publicKey: publicKey,
          transactionId: transactionId
        )
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func openFormToSaveCard(
    street: String,
    city: String,
    state: String,
    country: String,
    postalCode: String,
    logoUrl: String,
    userId: String,
    firstName: String,
    lastName: String,
    email: String,
    phoneNumber: String,
    documentType: String,
    documentNumber: String,
    environment: String,
    merchantCode: String,
    publicKey: String,
    transactionId: String
  ) {
    let date = Date()
    let milliseconds = Int(date.timeIntervalSince1970 * 1000)

    var configPayment = ConfigPaymentIzipay()
    configPayment.enviroment = environment
    configPayment.merchantCode = merchantCode

    configPayment.publicKey = publicKey

    configPayment.transactionId = transactionId
    configPayment.action = "register"  // "pay_token" //register

    configPayment.order = OrderPaymentIzipay()
    configPayment.order?.orderNumber = "10\(transactionId)"
    configPayment.order?.amount = "0.00"  // si action=register puede ser 0, si no
    configPayment.order?.currency = "PEN"
    configPayment.order?.processType = "autorize"
    configPayment.order?.payMethod = [PaymentMethodIzipay.card]  //[.all]
    configPayment.order?.merchantBuyerId = userId  //"MB10\(transactionId)"
    configPayment.order?.dateTimeTransaction = "\(milliseconds)"

    configPayment.billing = BillingPaymentIzipay()
    configPayment.billing?.firstName = firstName
    configPayment.billing?.lastName = lastName
    configPayment.billing?.email = email
    configPayment.billing?.phoneNumber = phoneNumber
    configPayment.billing?.street = street
    configPayment.billing?.city = city
    configPayment.billing?.state = state
    configPayment.billing?.country = country
    configPayment.billing?.postalCode = postalCode
    configPayment.billing?.documentType = documentType
    configPayment.billing?.document = documentNumber

    configPayment.shipping = ShippingPaymentIzipay()

    configPayment.token = TokenPaymentIzipay()

    configPayment.appearance = AppearencePaymentIzipay()
    configPayment.appearance?.theme = "purple"
    configPayment.appearance?.logo = logoUrl
    configPayment.appearance?.formControls = AppearenceControlsPaymentIzipay()
    configPayment.appearance?.formControls?.isAmountLabelVisible = false
    configPayment.appearance?.formControls?.isLangControlVisible = false
    configPayment.appearance?.language = "ESP"
    configPayment.appearance?.customTheme = CustomThemePaymentIzipay()

    configPayment.appearance?.visualSettings = AppearenceVisualSettingsPaymentIzipay()
    configPayment.appearance?.visualSettings?.presentationMode = .fullscreen

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
    let resultCode = paymentResult.code ?? ""

    if resultCode == "00" {
      let cardToken = paymentResult.response?.token?.cardToken

      print(cardToken ?? "No se encontró el cardToken")

      let dataToSend: [String: Any?] = [
        "success": true,
        "cardToken": cardToken,
      ]
      self.sendResultToFlutter(result: dataToSend)
    } else {
      let dataToSend: [String: Any?] = [
        "success": false,
        "cardToken": nil,
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
