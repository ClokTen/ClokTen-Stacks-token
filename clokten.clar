(import redstone-verify 'redstone-verify)
(import datasource "https://raw.githubusercontent.com/hstove/stacks-fungible-token/main/contracts/sip-010-trait.clar" (sip-010-trait))

(define-public contract-name "ClokTen")

(define-public contract-symbol "CLOK")

(define-public contract-decimals 6)

(define public contract-total-supply (uint 10))

(define contract-owner (caller))

(define map-balances (ok-map u1))

(define-public contract-token-uri "https://example.com/token-metadata")

(define contract-redstone-contract "SPDBEG5X8XD50SPM1JJH0E5CTXGDV5NJTKAKKR5V.redstone-verify")

(define-public contract-redstone-message-type "timestamp")

(define-public contract-redstone-message-entries "entries")

(define-public contract-redstone-message-signature "signature")

(define-public contract-redstone-update-interval 60)

(define contract-last-redstone-update (optional uint))

(define contract-last-btc-price (optional uint))

(define (get-current-btc-price)
  (let ((result (datasource.get-data "https://api.coindesk.com/v1/bpi/currentprice.json")))
    (if (result.err)
      (err (err u1))
      (begin
        (let ((btc-price (result.ok.json.bpi.USD.rate_float)))
          (ok btc-price))))))

(define-public (get-current-gas-price)
  (let ((result (blockchain-api get-current-gas-price)))
    (if (result.err)
      (err u1)
      (ok (result.ok.uint)))))

(define-public (update-redstone-data)
  (if (is-none? contract-last-redstone-update)
    (begin
      (let ((btc-price (get-current-btc-price)))
        (if (btc-price.err)
          (err (err u1))
          (begin
            (map-set contract-last-redstone-update (block-height))
            (map-set contract-last-btc-price (btc-price.ok))
            (ok (ok u1))))))  
    (begin
      (let ((current-height (block-height)))
        (if (>= (current-height) (+ (contract-last-redstone-update) (contract-redstone-update-interval)))
          (begin
            (let ((btc-price (get-current-btc-price)))
              (if (btc-price.err)
                (err (err u1))
                (begin
                  (map-set contract-last-redstone-update (block-height))
                  (map-set contract-last-btc-price (btc-price.ok))
                  (ok (ok u1)))))))))))

(define-public (mirror-btc-price)
  (let ((redstone-update-result (update-redstone-data)))
    (if (redstone-update-result.err)
      (err (err u1))
      (begin
        (let ((btc-price (contract-last-btc-price)))
          (if (is-none? btc-price)
            (err (err u1))
            (begin
              (let ((tx-sender (tx-sender))
                    (balances (map-get map-balances tx-sender))
                    (current-balance (map-get balances 0)))
                (if (>= (current-balance) (contract-total-supply))
                  (err (err u1))
                  (begin
                    (let ((additional-tokens (- (contract-total-supply) (current-balance))))
                      (if (> additional-tokens 0)
                        (begin
                          (let ((additional-stx-required (* 2100 2)))
                            (let ((gas-price (get-current-gas-price)))
                              (if (gas-price.err)
                                (err (err u1))
                                (let ((additional-stx-required (+ additional-stx-required (gas-price.ok)))))
                              (if (< additional-stx-required 500000000)
                                (begin
                                  (try! (ft-mint? contract-total-supply tx-sender))
                                  (ok (ok u1)))
                                (err (err u1))))))))))))))))))

(define-public (ft-mint? (amount uint) (recipient principal))
  (ft-mint? amount recipient))

(define-public (ft-burn? (amount uint) (sender principal))
  (ft-burn? amount sender))

(define-public (ft-transfer? (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (ft-transfer? amount sender recipient memo))

(define-public (get-name)
  (contract-name))

(define-public (get-symbol)
  (contract-symbol))

(define-public (get-decimals)
  (contract-decimals))

(define-public (get-balance (principal))
  (map-get map-balances principal 0))

(define-public (get-total-supply)
  (contract-total-supply))

(define-public (get-token-uri)
  (contract-token-uri))

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (ft-transfer? amount sender recipient memo))
