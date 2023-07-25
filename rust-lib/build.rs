use std::process::Command;

use uniffi_bindgen::generate_bindings;

fn main() {
    let udl_file = "./src/rust-lib.udl";
    let out_dir = "./bindings/";
    uniffi_build::generate_scaffolding(udl_file).unwrap();
    generate_bindings(udl_file.into(), 
        None, 
        vec!["swift", "python", "kotlin"], 
        Some(out_dir.into()), 
        None, 
        true).unwrap(); 

    Command::new("uniffi-bindgen-cs").arg("--out-dir").arg(out_dir).arg(udl_file).output().expect("Failed when generating C# bindings");
}