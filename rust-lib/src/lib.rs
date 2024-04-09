uniffi::include_scaffolding!("rust-lib");

use std::sync::Arc;

use qrcodegen::{QrCode, QrCodeEcc};
use thiserror::Error;

#[derive(Error, Debug)]
pub enum QrError {
    #[error("Error with message: `{error_text}`")]
    ErrorMessage { error_text: String }
}

impl QrError {
    pub fn message(msg: impl Into<String>) -> Self {
        Self::ErrorMessage { error_text: msg.into() }
    }
}

pub fn encode_text(text: &str, ecl: QrCodeEcc) -> Result<Arc<QrCode>, QrError> {
    QrCode::encode_text(text, ecl)
        .map(|qr| Arc::new(qr))
        .map_err(|e| QrError::message(e.to_string()))
}

pub fn generate_qr_code_svg(text: &str) -> String {
    let error_correction_level: QrCodeEcc = QrCodeEcc::Low;
    let qr: QrCode = QrCode::encode_text(text, error_correction_level).unwrap();
    to_svg_string(&qr, 4)
}

// from https://github.com/nayuki/QR-Code-generator/blob/master/rust/examples/qrcodegen-demo.rs
fn to_svg_string(qr: &QrCode, border: i32) -> String {
    assert!(border >= 0, "Border must be non-negative");
    let mut result = String::new();
    result += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    result += "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n";
    let dimension = qr.size().checked_add(border.checked_mul(2).unwrap()).unwrap();
    result += &format!(
        "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 {0} {0}\" stroke=\"none\">\n", dimension);
    result += "\t<rect width=\"100%\" height=\"100%\" fill=\"#FFFFFF\"/>\n";
    result += "\t<path d=\"";
    for y in 0 .. qr.size() {
        for x in 0 .. qr.size() {
            if qr.get_module(x, y) {
                if x != 0 || y != 0 {
                    result += " ";
                }
                result += &format!("M{},{}h1v1h-1z", x + border, y + border);
            }
        }
    }
    result += "\" fill=\"#000000\"/>\n";
    result += "</svg>\n";
    result
}