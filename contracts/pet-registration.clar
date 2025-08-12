;; Pet Registration Contract
;; Allows users to register their pets and view pet details safely

;; Map to store pet details
(define-map pets principal
  { name: (string-ascii 50),
    species: (string-ascii 30) })

;; Error constants
(define-constant err-already-registered (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-name (err u102))
(define-constant err-invalid-species (err u103))

;; Function 1: Register a pet
(define-public (register-pet (pet-name (string-ascii 50)) (pet-species (string-ascii 30)))
  (begin
    ;; Ensure pet not already registered for this owner
    (asserts! (is-none (map-get? pets tx-sender)) err-already-registered)

    ;; Validate name and species are not empty
    (asserts! (> (len pet-name) u0) err-invalid-name)
    (asserts! (> (len pet-species) u0) err-invalid-species)

    ;; Store the pet details
    (map-set pets tx-sender { name: pet-name, species: pet-species })
    (ok "Pet registered successfully")
  ))

;; Function 2: Get pet details by owner
(define-read-only (get-pet (owner principal))
  (match (map-get? pets owner)
    pet-details (ok pet-details)
    err-not-found))
