module faith_coin::faith_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{sender, TxContext};
    use sui::transfer;
    use std::option;
    use sui::url::{Self, Url};

    struct FAITH_COIN has drop {}

    fun init(coin_type: FAITH_COIN, ctx: &mut TxContext) {
        let treasury_cap = create_currency(coin_type, ctx);
        transfer::public_transfer(treasury_cap, sender(ctx));
    }

    fun create_currency<T: drop>(
        coin_type: T,
        ctx: &mut TxContext
    ): TreasuryCap<T> {
        let url = url::new_unsafe_from_bytes(b"https://faithcoin.org/assets/icon.png");

        let (treasury_cap, metadata) = coin::create_currency(
            coin_type,
            9,
            b"FCN",
            b"Faith Coin",
            b"Nicole Faith's First Coin",
            option::some(url),
            ctx
        );

        transfer::public_freeze_object(metadata);
        treasury_cap
    }

    public entry fun mint(
        cap: &mut TreasuryCap<FAITH_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(cap, amount, recipient, ctx);
    }

    #[test_only]
    public fun init_for_test(ctx: &mut TxContext) {
        init(FAITH_COIN{}, ctx);
    }
}
