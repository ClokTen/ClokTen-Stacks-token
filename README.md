# $ClokTen Token

Welcome to the official repository of the $ClokTen token, the STX token created by Clok Ten, a member of the Chi-Rock Nation and the mastermind behind ClokLand—a virtual world celebrating the four elements of Hip-Hop. This repository contains the smart contract for the $ClokTen token built on the Stacks blockchain.

## Overview

$ClokTen ($CLOK10) is a fungible token with a maximum supply of 1,000,000,000,000,000 (1 quadrillion). This token is integral to the ClokLand ecosystem, facilitating transactions, rewards, and other in-world utilities.

### Contract Information

- **Token Name:** ClokTen
- **Symbol:** CLOK10
- **Decimals:** 6
- **Max Supply:** 1,000,000,000,000,000 (1 quadrillion)
- **Blockchain:** Stacks
- **Token URI:** [ClokTen Metadata](https://gaia.hiro.so/hub/12LwT6sxpkWrUm6Q9in4m2gJf192nRGmWY/clokten-6-decimals.json)

### Error Codes

- **ERR-UNAUTHORIZED:** u401 - Unauthorized action attempted.
- **ERR-NOT-OWNER:** u402 - Action attempted by non-owner.
- **ERR-INVALID-PARAMETERS:** u403 - Invalid parameters provided.
- **ERR-NOT-ENOUGH-FUND:** u101 - Insufficient funds for the transaction.

## SIP-10 Functions

The $ClokTen token implements the SIP-010 Fungible Token Standard, allowing for secure and standardized token operations. Key functions include:

- **Transfer Tokens:**
  ```clarity
  (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
