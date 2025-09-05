;; ----------------------------------------------
;; Decentralized Micro-Lending Vault (DMLV)
;; Contract: micro-loan-pool.clar
;; ----------------------------------------------

;; -----------------------------
;; VARIABLES & CONSTANTS
;; -----------------------------
(define-data-var admin principal tx-sender)
(define-data-var pool-balance uint u0)

;; Optional: Track each donor's total contributions
(define-map donors principal uint)

;; -----------------------------
;; 1. Fund the Lending Pool
;; -----------------------------
(define-public (fund-pool (amount uint))
  (begin
    (asserts! (> amount u0) (err u100)) ;; Reject zero-value transfers

    ;; Transfer STX into the contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Update global pool balance
    (var-set pool-balance (+ (var-get pool-balance) amount))

    ;; Update individual donor history (optional)
    (let ((prev (default-to u0 (map-get? donors tx-sender))))
      (map-set donors tx-sender (+ prev amount)))

    (ok amount)))

;; -----------------------------
;; 2. Read-only: View Admin
;; -----------------------------
(define-read-only (get-admin)
  (ok (var-get admin)))

;; -----------------------------
;; 3. Read-only: View Pool Balance
;; -----------------------------
(define-read-only (get-pool-balance)
  (ok (var-get pool-balance)))

;; -----------------------------
;; 4. Read-only: View Donor Total
;; -----------------------------
(define-read-only (get-donor-total (who principal))
  (ok (default-to u0 (map-get? donors who))))