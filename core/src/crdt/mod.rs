//! CRDT (Conflict-free Replicated Data Types) implementations
//!
//! This module contains various CRDT data structures for building collaborative
//! applications without requiring coordination between replicas.
//!
//! # CRDTs Implemented
//!
//! - **PN-Counter:** Positive-Negative Counter for distributed counting
//! - **OR-Set:** Observed-Remove Set for add/remove operations (TODO)
//! - **Fractional Index:** Position-based list ordering (TODO)
//! - **Text CRDT:** Block-based text editing (TODO)
//!
//! # References
//!
//! - "A comprehensive study of CRDTs" by Marc Shapiro et al.
//! - "Conflict-free Replicated Data Types" (INRIA Research Report 7687)

pub mod pn_counter;
pub mod or_set;
pub mod fractional_index;
// TODO: Phase 3 - Implement text CRDT
// pub mod text;

pub use pn_counter::PNCounter;
pub use or_set::ORSet;
pub use fractional_index::FractionalIndex;
