use solana_program::{
    account_info::AccountInfo,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    msg,
};
use pyth_sdk_solana::{PriceFeed, PriceStatus}; // اتصال به Pyth Network

pub struct PriceOracle {
    pub price_feed: Pubkey, // آدرس اوراکل
}

impl PriceOracle {
    pub fn get_latest_price(&self, accounts: &[AccountInfo]) -> Result<f64, ProgramResult> {
        let feed = PriceFeed::new(&self.price_feed, accounts)?;
        
        if feed.status == PriceStatus::Trading {
            let price = feed.get_price_unchecked() as f64 / 10_f64.powi(feed.expo);
            msg!("Price: {}", price);
            Ok(price)
        } else {
            Err(Err::<f64, ProgramResult>::Err(ProgramResult::InvalidAccountData))
        }
    }
}
