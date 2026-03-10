#include "flutter_window.h"

#include <exception>
#include <optional>
#include <string>

#include <flutter/encodable_value.h>
#include <flutter/standard_method_codec.h>
#include <shobjidl_core.h>
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.Services.Store.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

constexpr auto kWindowsIapChannelName = "tsuzuki/windows_iap";
constexpr auto kMethodIsStoreAvailable = "isStoreAvailable";
constexpr auto kMethodGetProductPrice = "getProductPrice";
constexpr auto kMethodPurchaseProduct = "purchaseProduct";
constexpr auto kMethodHasPurchasedProduct = "hasPurchasedProduct";

using flutter::EncodableMap;
using flutter::EncodableValue;
using StoreContext = winrt::Windows::Services::Store::StoreContext;
using StorePurchaseStatus = winrt::Windows::Services::Store::StorePurchaseStatus;

void InitializeStoreContextWindow(const StoreContext& context, HWND hwnd) {
  try {
    const auto initializer = context.as<IInitializeWithWindow>();
    initializer->Initialize(hwnd);
  } catch (...) {
    // Ignore; purchase APIs may still work without explicit window assignment.
  }
}

std::optional<std::string> ExtractProductId(
    const flutter::MethodCall<EncodableValue>& call) {
  const auto* raw_args = call.arguments();
  if (!raw_args) {
    return std::nullopt;
  }

  const auto* args = std::get_if<EncodableMap>(raw_args);
  if (!args) {
    return std::nullopt;
  }

  const auto it = args->find(EncodableValue("productId"));
  if (it == args->end()) {
    return std::nullopt;
  }

  if (const auto* product_id = std::get_if<std::string>(&it->second);
      product_id != nullptr && !product_id->empty()) {
    return *product_id;
  }

  return std::nullopt;
}

StoreContext CreateStoreContext(HWND hwnd) {
  auto context = StoreContext::GetDefault();
  if (context) {
    InitializeStoreContextWindow(context, hwnd);
  }
  return context;
}

bool HasPurchasedProduct(const StoreContext& context,
                         const std::string& product_id) {
  const auto license = context.GetAppLicenseAsync().get();
  const auto add_on_licenses = license.AddOnLicenses();
  const auto store_id = winrt::to_hstring(product_id);
  if (!add_on_licenses.HasKey(store_id)) {
    return false;
  }

  return add_on_licenses.Lookup(store_id).IsActive();
}

std::string GetProductPrice(const StoreContext& context,
                            const std::string& product_id) {
  auto product_types = winrt::single_threaded_vector<winrt::hstring>();
  product_types.Append(L"Durable");

  auto product_ids = winrt::single_threaded_vector<winrt::hstring>();
  const auto store_id = winrt::to_hstring(product_id);
  product_ids.Append(store_id);

  const auto result = context.GetStoreProductsAsync(product_types, product_ids).get();
  const auto products = result.Products();
  if (!products.HasKey(store_id)) {
    return "";
  }

  const auto price = products.Lookup(store_id).Price();
  auto formatted = price.FormattedRecurrencePrice();
  if (formatted.empty()) {
    formatted = price.FormattedPrice();
  }
  return winrt::to_string(formatted);
}

EncodableMap PurchaseProduct(const StoreContext& context,
                             const std::string& product_id) {
  EncodableMap payload;
  payload[EncodableValue("success")] = EncodableValue(false);
  payload[EncodableValue("alreadyOwned")] = EncodableValue(false);
  payload[EncodableValue("status")] = EncodableValue("unknown");

  const auto result = context.RequestPurchaseAsync(winrt::to_hstring(product_id)).get();
  switch (result.Status()) {
    case StorePurchaseStatus::Succeeded:
      payload[EncodableValue("success")] = EncodableValue(true);
      payload[EncodableValue("status")] = EncodableValue("succeeded");
      break;
    case StorePurchaseStatus::AlreadyPurchased:
      payload[EncodableValue("success")] = EncodableValue(true);
      payload[EncodableValue("alreadyOwned")] = EncodableValue(true);
      payload[EncodableValue("status")] = EncodableValue("alreadyPurchased");
      break;
    case StorePurchaseStatus::NotPurchased:
      payload[EncodableValue("status")] = EncodableValue("notPurchased");
      break;
    case StorePurchaseStatus::NetworkError:
      payload[EncodableValue("status")] = EncodableValue("networkError");
      break;
    case StorePurchaseStatus::ServerError:
      payload[EncodableValue("status")] = EncodableValue("serverError");
      break;
    default:
      payload[EncodableValue("status")] = EncodableValue("unknown");
      break;
  }

  return payload;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  windows_iap_channel_ =
      std::make_unique<flutter::MethodChannel<EncodableValue>>(
          flutter_controller_->engine()->messenger(),
          kWindowsIapChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  windows_iap_channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        try {
          const auto context = CreateStoreContext(this->GetHandle());
          if (call.method_name() == kMethodIsStoreAvailable) {
            result->Success(EncodableValue(static_cast<bool>(context)));
            return;
          }

          if (!context) {
            result->Error(
                "store_unavailable",
                "Microsoft Store context is unavailable. Run as a packaged app.");
            return;
          }

          const auto product_id = ExtractProductId(call);
          if (!product_id.has_value()) {
            result->Error("invalid_arguments", "Missing productId");
            return;
          }

          if (call.method_name() == kMethodGetProductPrice) {
            const auto price = GetProductPrice(context, *product_id);
            if (price.empty()) {
              result->Success();
            } else {
              result->Success(EncodableValue(price));
            }
            return;
          }

          if (call.method_name() == kMethodHasPurchasedProduct) {
            result->Success(
                EncodableValue(HasPurchasedProduct(context, *product_id)));
            return;
          }

          if (call.method_name() == kMethodPurchaseProduct) {
            result->Success(EncodableValue(PurchaseProduct(context, *product_id)));
            return;
          }

          result->NotImplemented();
        } catch (const winrt::hresult_error& e) {
          result->Error("store_error", winrt::to_string(e.message()));
        } catch (const std::exception& e) {
          result->Error("store_error", e.what());
        }
      });
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  windows_iap_channel_.reset();
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
