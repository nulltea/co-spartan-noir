#![allow(missing_docs)]
mod cmd;
mod measuring_alloc;
mod span_stats;

use anyhow::Result;
use tracing_subscriber::{self, layer::SubscriberExt as _, Registry};

use self::{cmd::Command, measuring_alloc::MeasuringAllocator, span_stats::SpanStats};

#[global_allocator]
static ALLOC: MeasuringAllocator = MeasuringAllocator::new();

fn main() -> Result<()> {
    let subscriber = Registry::default().with(SpanStats);
    tracing::subscriber::set_global_default(subscriber)?;

    // Run CLI command
    let args = argh::from_env::<cmd::Args>();
    args.run()
}
