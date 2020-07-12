use serde::Deserialize;
use std::path::PathBuf;
use structopt::StructOpt;

#[derive(StructOpt)]
#[structopt(name = "rustcont", about = "My Rust Container Program")]
struct Opt {
    #[structopt(short, long)]
    config: PathBuf,
}

#[derive(Deserialize)]
struct Config {
    port: Option<u16>,
}

fn main() {
    let opt = Opt::from_args();

    let config_toml = std::fs::read_to_string(opt.config).unwrap();
    let config: Config = toml::from_str(&config_toml).unwrap();

    println!("port: {:?}", config.port);
}
